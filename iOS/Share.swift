import UIKit

extension UIActivityViewController {
    class func share(web: Web) -> UIActivityViewController {
        .init(activityItems: [web.url ?? ""],
              applicationActivities: [
                Print(web: web),
                PDF(web: web),
                Download(web: web),
                Snapshot(web: web),
                Archive(web: web)])
    }
}

private class Option: UIActivity {
    private(set) weak var web: Web?
    final override class var activityCategory: UIActivity.Category { .action }

    init(web: Web) {
        self.web = web
        super.init()
    }

    final override func canPerform(withActivityItems: [Any]) -> Bool {
        true
    }

    final func controller(with: Any) -> UIViewController {
        let controller = UIActivityViewController(activityItems: [with], applicationActivities: nil)
        controller.completionWithItemsHandler = { [weak self] _, _, _, _ in
            self?.activityDidFinish(true)
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let navigation = UINavigationController(rootViewController: controller)
            navigation.setNavigationBarHidden(true, animated: false)
            return navigation
        } else {
            return controller
        }
    }
}

private final class Print: Option {
    override var activityTitle: String? { "Print" }
    override var activityImage: UIImage? { .init(systemName: "printer") }

    override func perform() {
        UIPrintInteractionController.shared.printFormatter = web?.viewPrintFormatter()
        UIPrintInteractionController.shared.present(animated: true)
        activityDidFinish(true)
    }
}

private final class PDF: Option {
    override var activityTitle: String? { "PDF" }
    override var activityImage: UIImage? { .init(systemName: "doc.richtext") }
    private var pdf: Data?

    @MainActor override func prepare(withActivityItems: [Any]) {
        Task {
            pdf = try? await web?.pdf()
        }
    }

    override var activityViewController: UIViewController? {
        guard
            let pdf = pdf,
            let name = web?.url?.file("pdf")
        else {
            return nil
        }
        return controller(with: pdf.temporal(name))
    }
}

private final class Download: Option {
    override var activityTitle: String? { "Download" }
    override var activityImage: UIImage? { .init(systemName: "square.and.arrow.down") }

    override var activityViewController: UIViewController? {
        guard let download = web?.url?.download else {
            return nil
        }
        return controller(with: download)
    }
}

private final class Snapshot: Option {
    override var activityTitle: String? { "Snapshot" }
    override var activityImage: UIImage? { .init(systemName: "text.below.photo.fill") }
    private var snapshot: UIImage?

    @MainActor override func prepare(withActivityItems: [Any]) {
        Task {
            snapshot = try? await web?.takeSnapshot(configuration: nil)
        }
    }

    override var activityViewController: UIViewController? {
        guard
            let snapshot = snapshot?.pngData(),
            let name = web?.url?.file("png")
        else {
            return nil
        }
        return controller(with: snapshot.temporal(name))
    }
}

private final class Archive: Option {
    override var activityTitle: String? { "Web archive" }
    override var activityImage: UIImage? { .init(systemName: "doc.zipper") }
    private var data: Data?

    override func prepare(withActivityItems: [Any]) {
        web?
            .createWebArchiveData { [weak self] in
                guard case let .success(data) = $0 else { return }
                self?.data = data
            }
    }

    override var activityViewController: UIViewController? {
        guard
            let data = data,
            let name = web?.url?.file("webarchive")
        else {
            return nil
        }
        return controller(with: data.temporal(name))
    }
}
