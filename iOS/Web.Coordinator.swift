import WebKit
import Combine
import Sleuth

extension Web {
    final class Coordinator: Webview {
        weak var newTab: PassthroughSubject<URL, Never>!
        
        required init?(coder: NSCoder) { nil }
        init(wrapper: Web, id: UUID, browse: Int) {
            newTab = wrapper.session.newTab
            var settings = wrapper.session.archive.settings
            
            if !UIApplication.dark {
                settings.dark = false
            }
            
            let configuration = WKWebViewConfiguration()
            configuration.dataDetectorTypes = [.link]
            configuration.defaultWebpagePreferences.preferredContentMode = .mobile
            configuration.allowsInlineMediaPlayback = true
            configuration.ignoresViewportScaleLimits = true
            
            super.init(configuration: configuration, session: wrapper.session, id: id, browse: browse, settings: settings)
            scrollView.keyboardDismissMode = .none
            scrollView.contentInsetAdjustmentBehavior = .never
            scrollView.clipsToBounds = false
            isOpaque = !settings.dark
            scrollView.backgroundColor = .secondarySystemBackground
            scrollView.indicatorStyle = settings.dark ? .white : .default

            wrapper
                .session
                .load
                .filter {
                    $0.id == id
                }
                .sink { [weak self] in
                    self?.load($0.access)
                }
                .store(in: &subs)
            
            wrapper
                .session
                .reload
                .filter {
                    $0 == id
                }
                .sink { [weak self] _ in
                    self?.reload()
                }
                .store(in: &subs)
            
            wrapper
                .session
                .stop
                .filter {
                    $0 == id
                }
                .sink { [weak self] _ in
                    self?.stopLoading()
                }
                .store(in: &subs)
            
            wrapper
                .session
                .back
                .filter {
                    $0 == id
                }
                .sink { [weak self] _ in
                    self?.goBack()
                }
                .store(in: &subs)
            
            wrapper
                .session
                .forward
                .filter {
                    $0 == id
                }
                .sink { [weak self] _ in
                    self?.goForward()
                }
                .store(in: &subs)
            
            wrapper
                .session
                .print
                .filter {
                    $0 == id
                }
                .sink { [weak self] _ in
                    UIPrintInteractionController.shared.printFormatter = self?.viewPrintFormatter()
                    UIPrintInteractionController.shared.present(animated: true)
                }
                .store(in: &subs)

            wrapper
                .session
                .pdf
                .filter {
                    $0 == id
                }
                .sink { [weak self] _ in
                    self?.createPDF {
                        guard
                            case let .success(data) = $0,
                            let name = self?.url?.file("pdf")
                        else { return }
                        UIApplication.shared.share(data.temporal(name))
                    }
                }
                .store(in: &subs)
            
            wrapper
                .session
                .webarchive
                .filter {
                    $0 == id
                }
                .sink { [weak self] _ in
                    self?.createWebArchiveData {
                        guard
                            case let .success(data) = $0,
                            let name = self?.url?.file("webarchive")
                        else { return }
                        UIApplication.shared.share(data.temporal(name))
                    }
                }
                .store(in: &subs)
            
            wrapper
                .session
                .snapshot
                .filter {
                    $0 == id
                }
                .sink { [weak self] _ in
                    self?.takeSnapshot(with: nil) { image, _ in
                        guard
                            let data = image?.pngData(),
                            let name = self?.url?.file("png")
                        else { return }
                        UIApplication.shared.share(data.temporal(name))
                    }
                }
                .store(in: &subs)
            
            wrapper
                .session
                .find
                .filter {
                    $0.0 == id
                }
                .map {
                    $0.1
                }
                .sink { [weak self] in
                    self?.find($0) {
                        guard $0.matchFound else { return }
                        self?.evaluateJavaScript(Script.highlight) { offset, _ in
                            offset
                                .flatMap {
                                    $0 as? CGFloat
                                }
                                .map {
                                    self?.found($0)
                                }
                        }
                    }
                }
                .store(in: &subs)
        }
        
        deinit {
            scrollView.delegate = nil
        }
        
        override func external(_ url: URL) {
            UIApplication.shared.open(url)
        }
        
        func webView(_: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
            UIApplication.shared.resign()
        }

        func webView(_: WKWebView, createWebViewWith: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if (action.targetFrame == nil && action.navigationType == .other) || action.navigationType == .linkActivated {
                _ = action
                    .request
                    .url
                    .map(load)
            }
            return nil
        }
        
        func webView(_: WKWebView, contextMenuConfigurationForElement: WKContextMenuElementInfo, completionHandler: @escaping (UIContextMenuConfiguration?) -> Void) {
            completionHandler(.init(identifier: nil, previewProvider: nil, actionProvider: { elements in
                var elements = elements
                    .filter {
                        guard let name = ($0 as? UIAction)?.identifier.rawValue else { return true }
                        return !(name.hasSuffix("Open") || name.hasSuffix("List"))
                    }
                
                if let url = contextMenuConfigurationForElement
                    .linkURL {
                        elements
                            .insert(UIAction(title: NSLocalizedString("Open in new tab", comment: ""),
                                             image: UIImage(systemName: "plus.square.on.square"))
                            { [weak self] _ in
                                self?.newTab.send(url)
                            }, at: 0)
                    }
                return .init(title: "", children: elements)
            }))
        }
        
        func webView(_: WKWebView, contextMenuForElement element: WKContextMenuElementInfo, willCommitWithAnimator: UIContextMenuInteractionCommitAnimating) {
            if let url = element.linkURL {
                load(url)
            } else if let data = (willCommitWithAnimator.previewViewController?.view.subviews.first as? UIImageView)?.image?.pngData() {
                load(data.temporal("image.png"))
            }
        }
        
        private func found(_ offset: CGFloat) {
            scrollView.scrollRectToVisible(.init(x: 0,
                                                 y: offset + scrollView.contentOffset.y - (offset > 0 ? 160 : -180),
                                                 width: 320,
                                                 height: 320),
                                           animated: true)
        }
    }
}
