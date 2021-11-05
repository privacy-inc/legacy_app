import WebKit
import Combine
import UniformTypeIdentifiers
import UserNotifications
import Specs

final class Web: Webview, NSTextFinderBarContainer {
//    private var destination = Destination.window
    
    let item: UUID
    private weak var status: Status!
    private let finder = NSTextFinder()
    
    required init?(coder: NSCoder) { nil }
    init(status: Status, item: UUID, history: UInt16, settings: Specs.Settings.Configuration) {
        self.status = status
        self.item = item
        
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.preferredContentMode = .desktop
        configuration.preferences.setValue(true, forKey: "fullScreenEnabled")
        
        let dark = NSApp.effectiveAppearance.name != .aqua
        
        if dark && settings.dark {
            configuration.setValue(false, forKey: "drawsBackground")
        }
        
        super.init(configuration: configuration, history: history, settings: settings, dark: dark)
        translatesAutoresizingMaskIntoConstraints = false
        customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15"
        
        finder.client = self
        finder.findBarContainer = self
        
        /*
        
        session
            .print
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                guard let self = self else { return }
                let info = NSPrintInfo.shared
                info.horizontalPagination = .automatic
                info.verticalPagination = .automatic
                info.isVerticallyCentered = false
                info.isHorizontallyCentered = false
                info.leftMargin = 10
                info.rightMargin = 10
                info.topMargin = 10
                info.bottomMargin = 10
                let operation = self.printOperation(with: info)
                operation.showsPrintPanel = false
                operation.showsProgressPanel = false
                operation.runModal(for: self.window!, delegate: nil, didRun: nil, contextInfo: nil)
            }
            .store(in: &subs)

        session
            .pdf
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                self?.createPDF {
                    guard
                        case let .success(data) = $0,
                        let title = self?.title
                    else { return }
                    NSSavePanel.save(data: data, name: title, type: "pdf")
                }
            }
            .store(in: &subs)
        
        session
            .webarchive
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                self?.createWebArchiveData {
                    guard
                        case let .success(data) = $0,
                        let title = self?.title
                    else { return }
                    NSSavePanel.save(data: data, name: title, type: "webarchive")
                }
            }
            .store(in: &subs)
        
        session
            .snapshot
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                self?.takeSnapshot(with: nil) { image, _ in
                    guard
                        let tiff = image?.tiffRepresentation,
                        let data = NSBitmapImageRep(data: tiff)?.representation(using: .png, properties: [:]),
                        let title = self?.title
                    else { return }
                    NSSavePanel.save(data: data, name: title, type: "png")
                }
            }
            .store(in: &subs)
        
        session
            .actualSize
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                self?.pageZoom = 1
            }
            .store(in: &subs)
        
        session
            .zoomIn
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                self?.pageZoom *= 1.1
            }
            .store(in: &subs)
        
        session
            .zoomOut
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                self?.pageZoom /= 1.1
            }
            .store(in: &subs)*/
    }
    
    override func external(_ url: URL) {
        NSWorkspace.shared.open(url)
    }
    
    override func error(error: Err) {
        status.change(flow: .error(self, error), id: item)
    }
    
//    override func userContentController(_ controller: WKUserContentController, didReceive: WKScriptMessage) {
//        super.userContentController(controller, didReceive: didReceive)
//        
//        switch Script.Message(rawValue: didReceive.name) {
//        case .location:
//            guard (didReceive.body as? String) == "_privacy_incognit_location_request", settings.location else { return }
//            var sub: AnyCancellable?
//            sub = location
//                .current
//                .compactMap {
//                    $0
//                }
//                .sink { [weak self] in
//                    sub?.cancel()
//                    self?.evaluateJavaScript(
//                        "_privacy_incognit_location_received(\($0.coordinate.latitude), \($0.coordinate.longitude), \($0.horizontalAccuracy));")
//                }
//            location.request()
//        default:
//            break
//        }
//    }
    
    func webView(_: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
        window?.makeFirstResponder(self)
    }
    
    func webView(_: WKWebView, createWebViewWith: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        switch action.navigationType {
        case .linkActivated:
            _ = action
                .request
                .url
                .map(load)
        case .other:
            if action.targetFrame == nil {
//                action
//                    .request
//                    .url
//                    .map { url in
//                        switch destination {
//                        case let .tab(change):
//                            session.open.send((url: url, change: change))
//                        case .window:
//                            NSApp.newWindowWith(url: url)
//                        case .download:
//                            URLSession
//                                .shared
//                                .dataTaskPublisher(for: url)
//                                .map(\.data)
//                                .receive(on: DispatchQueue.main)
//                                .replaceError(with: .init())
//                                .sink {
//                                    NSSavePanel.save(data: $0, name: url.lastPathComponent, type: nil)
//                                }
//                                .store(in: &subs)
//                            break
//                        }
//                        destination = .window
//                    }
            }
        default:
            break
        }
        return nil
    }
    
    override func willOpenMenu(_ menu: NSMenu, with: NSEvent) {
//        menu.remove(id: "WKMenuItemIdentifierOpenLink")
//        menu.remove(id: "WKMenuItemIdentifierSearchWeb")
//        
//        if let image = menu.remove(id: "WKMenuItemIdentifierOpenImageInNewWindow") {
//            let tabStay = image.immitate(with: "Open Image in New Tab", action: #selector(tab(stay:)))
//            tabStay.target = self
//            
//            let tabChange = image.immitate(with: "Open Image in New Tab and Change", action: #selector(tab(change:)))
//            tabChange.target = self
//            
//            menu.items = [
//                tabStay,
//                tabChange,
//                image,
//                .separator()
//            ]
//            + menu.items
//            
//            menu
//                .mutate(id: "WKMenuItemIdentifierDownloadImage") {
//                    $0.target = self
//                    $0.action = #selector(download(item:))
//                    $0.representedObject = image
//                }
//        }
//        
//        if let window = menu.remove(id: "WKMenuItemIdentifierOpenLinkInNewWindow") {
//            window.title = "Open in New Window"
//            
//            let tabStay = window.immitate(with: "Open in New Tab", action: #selector(tab(stay:)))
//            tabStay.target = self
//            
//            let tabChange = window.immitate(with: "Open in New Tab and Change", action: #selector(tab(change:)))
//            tabChange.target = self
//            
//            menu.items = [
//                tabStay,
//                tabChange,
//                window,
//                .separator()
//            ]
//            + menu.items
//            
//            menu
//                .mutate(id: "WKMenuItemIdentifierDownloadLinkedFile") {
//                    $0.target = self
//                    $0.action = #selector(download(item:))
//                    $0.representedObject = window
//                }
//        }
    }
    
    override var isEditable: Bool {
        false
    }
//
//    @objc private func tab(change item: NSMenuItem) {
//        destination = .tab(true)
//        item.activate()
//    }
//
//    @objc private func tab(stay item: NSMenuItem) {
//        destination = .tab(false)
//        item.activate()
//    }
//
//    @objc private func download(item: NSMenuItem) {
//        destination = .download
//        item.activate()
//    }
    
    var findBarView: NSView? {
        didSet {
            oldValue?.removeFromSuperview()
            findBarView
                .map {
                    $0.removeFromSuperview()
                    $0.frame.size.width = 360
                    $0.frame.origin = .init(x: bounds.width - 370, y: bounds.height - ($0.frame.height + safeAreaInsets.top + 5))
                    $0.autoresizingMask = [.minXMargin, .minYMargin]
                    addSubview($0)
                }
        }
    }
    
    var isFindBarVisible = false {
        didSet {
            findBarView?
                .subviews
                .first?
                .subviews
                .filter {
                    !($0 is NSStackView)
                }
                .forEach {
                    $0.removeFromSuperview()
                }
            findBarView?.isHidden = !isFindBarVisible
        }
    }
    
    func findBarViewDidChangeHeight() {
        
    }
    
    override func performTextFinderAction(_ sender: Any?) {
        (sender as? NSMenuItem)
            .flatMap {
                NSTextFinder.Action(rawValue: $0.tag)
            }
            .map {
                finder.performAction($0)

                switch $0 {
                case .showFindInterface:
                    finder.findBarContainer?.isFindBarVisible = true
                default: break
                }
            }
    }
    
    @objc func share(_ item: NSMenuItem) {
        guard
            let url = url,
            let service = item.representedObject as? NSSharingService
        else { return }
        service.perform(withItems: [url])
    }
    
    @objc func saveAs() {
        saveAs(types: [])
    }
    
    @objc func exportAsWebarchive() {
        guard url?.pathExtension != "webarchive" else {
            saveAs(types: [.webArchive])
            return
        }
        createWebArchiveData { [weak self] in
            guard
                case let .success(data) = $0,
                let name = self?.url?.file("webarchive")
            else { return }
            NSSavePanel.save(data: data, name: name, types: [.webArchive])
        }
    }
    
   @objc func printPage() {
       let info = NSPrintInfo.shared
       info.horizontalPagination = .automatic
       info.verticalPagination = .automatic
       info.isVerticallyCentered = false
       info.isHorizontallyCentered = false
       info.leftMargin = 10
       info.rightMargin = 10
       info.topMargin = 10
       info.bottomMargin = 10
       
       let operation = printOperation(with: info)
       operation.view?.frame = bounds
       operation.runModal(for: window!, delegate: nil, didRun: nil, contextInfo: nil)
    }
    
    @objc func actualSize() {
        pageZoom = 1
    }
    
    @objc func zoomIn() {
        pageZoom *= 1.1
    }
    
    @objc func zoomOut() {
        pageZoom /= 1.1
    }
    
    @objc func tryAgain() {
        if case let .error(_, error) = status.item.flow {
            load(error.url)
            status.change(flow: .web(self), id: item)
        }
    }
    
    @objc func dismiss() {
        Task
            .detached(priority: .utility) { [weak self] in
                await self?.status.dismiss()
            }
    }
    
    @objc func copyLink() {
        guard let url = url else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(url.absoluteString, forType: .string)
        
        Task
            .detached(priority: .utility) {
                await UNUserNotificationCenter.send(message: "Link URL copied")
            }
    }
    
    @MainActor @objc func exportAsPdf() {
        guard url?.pathExtension.lowercased() != "pdf" else {
            saveAs(types: [.pdf])
            return
        }
        Task {
            guard
                let name = url?.file("pdf"),
                let pdf = try? await pdf()
            else { return }
            NSSavePanel.save(data: pdf, name: name, types: [.pdf])
        }
    }
    
    @MainActor @objc func exportAsSnapshot() {
        switch url?.pathExtension.lowercased() {
        case "png":
            saveAs(types: [.png])
        case "jpg", "jpeg":
            saveAs(types: [.jpeg])
        case "bmp":
            saveAs(types: [.bmp])
        case "gif":
            saveAs(types: [.gif])
        default:
            Task {
                guard
                    let name = url?.file("png"),
                    let image = try? await takeSnapshot(configuration: nil),
                    let tiff = image.tiffRepresentation,
                    let data = NSBitmapImageRep(data: tiff)?.representation(using: .png, properties: [:])
                else { return }
                NSSavePanel.save(data: data, name: name, types: [.png])
            }
        }
    }
    
    private func saveAs(types: [UTType]) {
        url?
            .download
            .map { download in
                (try? Data(contentsOf: download))
                    .map {
                        NSSavePanel.save(data: $0, name: download.lastPathComponent, types: types)
                    }
            }
    }
}
