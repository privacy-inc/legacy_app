import WebKit
import Combine
import Specs

final class Web: Webview {
//    private var destination = Destination.window
    
    required init?(coder: NSCoder) { nil }
    init(history: UInt16, settings: Specs.Settings.Configuration) {
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
        
        /*
        session
            .load
            .filter {
                $0.id == id
            }
            .sink { [weak self] in
                self?.load($0.access)
            }
            .store(in: &subs)
        
        session
            .reload
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                self?.reload()
            }
            .store(in: &subs)
        
        session
            .stop
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                self?.stopLoading()
            }
            .store(in: &subs)
        
        session
            .back
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                self?.goBack()
            }
            .store(in: &subs)
        
        session
            .forward
            .filter {
                $0 == id
            }
            .sink { [weak self] _ in
                self?.goForward()
            }
            .store(in: &subs)
        
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
//        self.error.send(error)
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
}
