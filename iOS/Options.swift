import SwiftUI
import Combine
import Specs

final class Options: UIHostingController<Options.Content>, UIViewControllerRepresentable, UIViewControllerTransitioningDelegate {
    deinit {
        print("options gone")
    }
    
    private var sub: AnyCancellable?
    
    required init?(coder: NSCoder) { nil }
    init(web: Web) {
        print("options init")
        
        let share = PassthroughSubject<Void, Never>()
        
        super.init(rootView: .init(web: web, share: share))
        modalPresentationStyle = .overCurrentContext
        
        sub = share
            .sink { [weak self] in
                guard let self = self else { return }
                Task {
                    await self.share(history: web.history)
                }
            }
    }
    
    override func willMove(toParent: UIViewController?) {
        super.willMove(toParent: toParent)
        parent?.modalPresentationStyle = .overCurrentContext
        parent?.view.backgroundColor = .clear
        view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sheetPresentationController
            .map {
                $0.detents = [.medium()]
                $0.preferredCornerRadius = 16
            }
    }
    
    func makeUIViewController(context: Context) -> Options {
        self
    }
    
    func updateUIViewController(_: Options, context: Context) {

    }
    
    private func share(history: UInt16) async {
        guard
            let access = await cloud.website(history: history).access as? AccessURL,
            let url = access.url
        else { return }
        
        let controller = UIActivityViewController(activityItems: [url], applicationActivities: [Safari()])
        controller.transitioningDelegate = self
        controller.popoverPresentationController?.sourceView = view
        present(controller, animated: true)
    }
    
    func animationController(forDismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DispatchQueue
            .main
            .async { [weak self] in
                self?.dismiss(animated: true)
            }
        return nil
    }
}

private final class Safari: UIActivity {
    override var activityTitle: String? { "Open in Safari" }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        true
    }
    
    override func perform() {
        UIApplication.shared.open(URL(string: "safari-http://www.wikipedia.org")!)
    }
}

private final class SaveToFiles: UIActivity {
//    override var activityTitle: String? { .localized(.saveToFiles) }
//    override var activityImage: UIImage? { UIImage(named: "folder")! }
//    private var destination: URL?
//    private let origin: URL
//    private let data: Data
//
//    init(origin: URL, data: Data) {
//        self.origin = origin
//        self.data = data
//        super.init()
//    }
//
//    override func canPerform(withActivityItems: [Any]) -> Bool {
//        true
//    }
//
//    override func prepare(withActivityItems: [Any]) {
//        destination = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(origin.lastPathComponent)
//        try? data.write(to: destination!, options: .atomic)
//        Analytics.shared.shareContent(.send_to_files)
//    }
//
//    override var activityViewController: UIViewController? {
//        UIDocumentPickerViewController(url: destination ?? origin, in: .exportToService)
//    }
}


/*
 struct Options: View {
     @Binding var session: Session
     let id: UUID
     @Environment(\.presentationMode) private var visible
     
     var body: some View {
         Popup(title: "Sharing options", leading: { }) {
             List {
                 Section(
                     header: Text("URL")) {
                     Control(title: "Share", image: "square.and.arrow.up") {
                         UIApplication.shared.share(string)
                     }
                     Control(title: "Copy", image: "doc.on.doc") {
                         dismiss()
                         session.toast = .init(title: "URL copied", icon: "doc.on.doc.fill")
                         UIPasteboard.general.string = string
                     }
                 }
                 Section(
                     header: Text("Page")) {
                     Control(title: "Share", image: "square.and.arrow.up") {
                         url
                             .map(UIApplication.shared.share)
                     }
                     Control(title: "Download", image: "square.and.arrow.down") {
                         download
                             .map(UIApplication.shared.share)
                     }
                     Control(title: "Print", image: "printer") {
                         session.print.send(id)
                     }
                     Control(title: "Snapshot", image: "text.below.photo.fill") {
                         session.snapshot.send(id)
                     }
                 }
                 Section(
                     header: Text("Export")) {
                     Control(title: "PDF", image: "doc.richtext") {
                         session.pdf.send(id)
                     }
                     Control(title: "Web archive", image: "doc.zipper") {
                         session.webarchive.send(id)
                     }
                 }
                 Section(
                     header: Text("Image")) {
                     Control(title: "Add to Photos", image: "photo") {
                         dismiss()
                         url
                             .flatMap {
                                 try? Data(contentsOf: $0)
                             }
                             .flatMap(UIImage.init(data:))
                             .map {
                                 UIImageWriteToSavedPhotosAlbum($0, nil, nil, nil)
                                 session.toast = .init(title: "Added to Photos", icon: "photo")
                             }
                     }
                     .opacity(photo ? 1 : 0.3)
                 }
                 .disabled(!photo)
             }
             .listStyle(GroupedListStyle())
         }
     }
     
     private var string: String {
         session
             .items[state: id]
             .browse
             .map(session.archive.page)
             .map(\.access.value)
         ?? ""
     }
     
     private var url: URL? {
         .init(string: string)
     }
     
     private var download: URL? {
         url?.download
     }
     
     private var photo: Bool {
         switch string.components(separatedBy: ".").last!.lowercased() {
         case "png", "jpg", "jpeg", "bmp", "gif": return true
         default: return false
         }
     }
     
     private func dismiss() {
         visible.wrappedValue.dismiss()
     }
 }
 */
