import UIKit
import Specs

extension Options {
    final class Share: UIActivityViewController {
        init(web: Web, content: Any?) {
            var activities = [Download(web: web), Print()]

            content
                .flatMap {
                    $0 as? String
                }
                .map {
                    if $0.contains("image") {
                        activities.insert(Photos(web: web), at: 0)
                    }
                }
            
            super.init(
                activityItems: [web.url ?? ""],
                applicationActivities: activities)
        }
    }
}

private class Option: UIActivity {
    private(set) weak var web: Web?
    
    init(web: Web) {
        self.web = web
        super.init()
    }
    
    func controller(with: Any) -> UIViewController {
        let controller = UIActivityViewController(activityItems: [with], applicationActivities: nil)
        controller.completionWithItemsHandler = { [weak self] _, _, _, _ in
            self?.activityDidFinish(true)
        }
        return controller
    }
}

private final class Photos: Option {
    override var activityTitle: String? { "Add to Photos" }
    override var activityImage: UIImage? { .init(systemName: "photo") }
    
    override func canPerform(withActivityItems: [Any]) -> Bool {
        true
    }
    
    override func perform() {
        guard
            let url = web?.url,
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
        else {
            activityDidFinish(false)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        Task {
            await UNUserNotificationCenter.send(message: "Added to Photos")
        }
        
        activityDidFinish(true)
    }
}

private final class Download: Option {
    override var activityTitle: String? { "Download" }
    override var activityImage: UIImage? { .init(systemName: "square.and.arrow.down") }
    
    override func canPerform(withActivityItems: [Any]) -> Bool {
        true
    }
    
    override var activityViewController: UIViewController? {
        guard let download = web?.url?.download else {
            return nil
        }
        return controller(with: download)
    }
}

private final class Print: UIActivity {
    override var activityTitle: String? { "Print" }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        true
    }
    
    override var activityViewController: UIViewController? {
        let controller = UIActivityViewController(activityItems: ["hello world"], applicationActivities: nil)
//        controller.popoverPresentationController?.sourceView = view
        controller.completionWithItemsHandler = { [weak self] _, _, _, _ in
            self?.activityDidFinish(true)
        }
        return controller
    }
    
    override func perform() {
        UIApplication.shared.open(URL(string: "safari-http://www.wikipedia.org")!)
    }
}

private final class Snapshot: UIActivity {
    override var activityTitle: String? { "Open in Safari" }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        true
    }
    
    override func perform() {
        UIApplication.shared.open(URL(string: "safari-http://www.wikipedia.org")!)
    }
}

private final class PDF: UIActivity {
    override var activityTitle: String? { "Open in Safari" }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        true
    }
    
    override func perform() {
        UIApplication.shared.open(URL(string: "safari-http://www.wikipedia.org")!)
    }
}

private final class Archive: UIActivity {
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


//
//func mimeType() -> String {
//        let pathExtension = self.pathExtension
//        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
//            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
//                return mimetype as String
//            }
//        }
//        return "application/octet-stream"
//    }
//    var containsImage: Bool {
//        let mimeType = self.mimeType()
//        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
//            return false
//        }
//        return UTTypeConformsTo(uti, kUTTypeImage)
//    }
//    var containsAudio: Bool {
//        let mimeType = self.mimeType()
//        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
//            return false
//        }
//        return UTTypeConformsTo(uti, kUTTypeAudio)
//    }
//    var containsVideo: Bool {
//        let mimeType = self.mimeType()
//        guard  let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
//            return false
//        }
//        return UTTypeConformsTo(uti, kUTTypeMovie)
//    }
