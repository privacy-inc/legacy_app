import WebKit
import Combine
import UniformTypeIdentifiers
import StoreKit
import Specs

final class Web: Webview {
    private var destination: Destination?
    private let session: Session
    private let id: UUID
    
    override var isEditable: Bool {
        false
    }
    
    required init?(coder: NSCoder) { nil }
    init(session: Session,
         id: UUID,
         settings: Specs.Settings.Configuration) {
        
        self.session = session
        self.id = id
        
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.preferredContentMode = .desktop
        configuration.preferences.setValue(true, forKey: "fullScreenEnabled")
        configuration.setValue(false, forKey: "drawsBackground")
        
        configuration.userContentController.addUserScript(.init(source: Script.location.script, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
        
        super.init(configuration: configuration, settings: settings, dark: NSApp.effectiveAppearance.name != .aqua)
        translatesAutoresizingMaskIntoConstraints = false
        allowsMagnification = true
        customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Safari/605.1.15"

        layer = Layer()
        wantsLayer = true
        layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        
        configuration.userContentController.addScriptMessageHandler(Location(), contentWorld: .page, name: Script.location.method)
    }
    
    override func deeplink(url: URL) {
        NSWorkspace.shared.open(url)
    }
    
    override func message(info: Info) {
        session.change(flow: .message(self, info), of: id)
    }
    
    override func reload(_ sender: Any?) {
        switch session.flow(of: id) {
        case .web:
            super.reload(sender)
        case let .message(_, info):
            info
                .url
                .map {
                    session.change(flow: .web(self), of: id)
                    load(url: $0)
                }
        default:
            break
        }
    }
    
    override func goBack(_ sender: Any?) {
        switch session.flow(of: id) {
        case .web:
            super.goBack(sender)
        case .message:
            if url == nil {
                session.addTab()
                session.close(id: id)
            } else {
                session.change(flow: .web(self), of: id)
            }
        default:
            break
        }
    }
    
    func webView(_: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
        window?.makeFirstResponder(self)
    }
    
    func webView(_: WKWebView, createWebViewWith: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        switch action.navigationType {
        case .linkActivated:
            if action.sourceFrame.isMainFrame {
                _ = action
                    .request
                    .url
                    .map(load)
            }
        case .other:
            if action.targetFrame == nil && action.sourceFrame.isMainFrame {
                action
                    .request
                    .url
                    .map { url in
                        switch destination {
                        case .here:
                            load(url: url)
                        case .tabStay:
                            NSApp.open(url: url, change: false)
                        case .tabChange:
                            NSApp.open(url: url, change: true)
                        case .window:
                            NSApp.window(url: url)
                        case .download:
                            Task
                                .detached(priority: .utility) { [weak self] in
                                    await self?.download(request: action.request)
                                }
                        case nil:
                            if settings.popups ||
                                action.request.url?.absoluteString.domain == action.sourceFrame.request.url?.absoluteString.domain {
                                NSApp.open(url: url, change: true)
                            }
                        }
                        destination = nil
                    }
            }
        default:
            break
        }
        return nil
    }
    
    override func willOpenMenu(_ menu: NSMenu, with: NSEvent) {        
        menu
            .items
            .remove {
                $0.identifier?.rawValue == "WKMenuItemIdentifierOpenLink"
                || $0.identifier?.rawValue == "WKMenuItemIdentifierSearchWeb"
            }

        menu
            .replace(id: "WKMenuItemIdentifierOpenImageInNewWindow",
                     download: "WKMenuItemIdentifierDownloadImage",
                     name: " Image",
                     web: self)

        menu
            .replace(id: "WKMenuItemIdentifierOpenLinkInNewWindow",
                     download: "WKMenuItemIdentifierDownloadLinkedFile",
                     name: "",
                     web: self)

        menu
            .replace(id: "WKMenuItemIdentifierOpenMediaInNewWindow",
                     download: "WKMenuItemIdentifierDownloadMedia",
                     name: " Video",
                     web: self)
        menu
            .items
            .append(contentsOf: [
                .separator(),
                .parent("Find...", [
                    .child("Image and..."),
                    .child("Open in New Tab", #selector(find(item:))) {
                        $0.target = self
                        $0.tag = Destination.tabChange.rawValue
                        $0.representedObject = Script.image.script
                    },
                    .child("Download", #selector(find(item:))) {
                        $0.target = self
                        $0.tag = Destination.download.rawValue
                        $0.representedObject = Script.image.script
                    },
                    .separator(),
                    .child("Video and..."),
                    .child("Open in New Tab", #selector(find(item:))) {
                        $0.target = self
                        $0.tag = Destination.tabChange.rawValue
                        $0.representedObject = Script.video.script
                    },
                    .child("Download", #selector(find(item:))) {
                        $0.target = self
                        $0.tag = Destination.download.rawValue
                        $0.representedObject = Script.video.script
                    }])])
    }
    
    override func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome: WKDownload) {
        super.webView(webView, navigationAction: navigationAction, didBecome: didBecome)
        (window as? Window)?.downloads.add(download: didBecome)
    }
    
    override func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome: WKDownload) {
        super.webView(webView, navigationResponse: navigationResponse, didBecome: didBecome)
        (window as? Window)?.downloads.add(download: didBecome)
    }
    
    override func download(_ download: WKDownload, didFailWithError: Error, resumeData: Data?) {
        super.download(download, didFailWithError: didFailWithError, resumeData: resumeData)
        (window as? Window)?.downloads.failed(download: download, data: resumeData)
    }
    
    override func downloadDidFinish(_ download: WKDownload) {
        super.downloadDidFinish(download)
        if Defaults.rate {
            SKStoreReviewController.requestReview()
        }
    }
    
    override func download(_ download: WKDownload, decideDestinationUsing: URLResponse, suggestedFilename: String) async -> URL? {
        let directory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        return FileManager.default.fileExists(atPath: directory.appendingPathComponent(suggestedFilename).path)
            ? directory.appendingPathComponent(UUID().uuidString + "_" + suggestedFilename)
            : directory.appendingPathComponent(suggestedFilename)
    }
    
    func webView(_: WKWebView, runOpenPanelWith: WKOpenPanelParameters, initiatedByFrame: WKFrameInfo) async -> [URL]? {
        let browse = NSOpenPanel()
        browse.allowsMultipleSelection = runOpenPanelWith.allowsMultipleSelection
        browse.canChooseDirectories = runOpenPanelWith.allowsDirectories
        browse.title = "Upload"
        browse.prompt = "Upload"
        guard browse.runModal() == .OK else { return nil }
        return browse.urls
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
            self?.save(data: data, name: name, types: [.webArchive])
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
    
    @objc func forward(item: NSMenuItem) {
        destination = .init(rawValue: item.tag)
        item.activate()
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
            save(data: pdf, name: name, types: [.pdf])
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
                save(data: data, name: name, types: [.png])
            }
        }
    }
    
    private func saveAs(types: [UTType]) {
        url?
            .download
            .map { download in
                (try? Data(contentsOf: download))
                    .map {
                        save(data: $0, name: download.lastPathComponent, types: types)
                    }
            }
    }
    
    private func download(request: URLRequest) async {
        let download = await startDownload(using: request)
        download.delegate = self
        (window as? Window)?.downloads.add(download: download)
    }
    
    @MainActor private func save(data: Data, name: String, types: [UTType]) {
        let panel = NSSavePanel()
        panel.nameFieldStringValue = name
        panel.allowedContentTypes = types
        panel.begin {
            if $0 == .OK, let url = panel.url {
                try? data.write(to: url, options: .atomic)
                NSWorkspace.shared.activateFileViewerSelecting([url])
                
                if Defaults.rate {
                    SKStoreReviewController.requestReview()
                }
            }
        }
    }
    
    @objc private func find(item: NSMenuItem) {
        Task {
            guard
                let script = item.representedObject as? String,
                let string = try? await evaluateJavaScript(script) as? String,
                let url = URL(string: string)
            else { return }
            
            if item.tag == Destination.download.rawValue {
                await download(request: .init(url: url))
            } else {
                NSApp.open(url: url, change: true)
            }
        }
    }
}
