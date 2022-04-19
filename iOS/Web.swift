import SwiftUI
import WebKit
import Combine
import Specs

final class Web: Webview, UIViewRepresentable {
//    let tab = PassthroughSubject<URL, Never>()
//    let error = PassthroughSubject<Err, Never>()
    private let session: Session

    @MainActor var fontSize: CGFloat {
        get async {
            guard
                let string = try? await evaluateJavaScript(Script.text.script) as? String,
                let int = Int(string.replacingOccurrences(of: "%", with: ""))
            else {
                return 1
            }
            return .init(int) / 100
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init(session: Session,
         settings: Specs.Settings.Configuration,
         dark: Bool) {
        
        self.session = session
        print("web")
        let configuration = WKWebViewConfiguration()
        configuration.dataDetectorTypes = [.link]
        configuration.defaultWebpagePreferences.preferredContentMode = .mobile
        configuration.allowsInlineMediaPlayback = true
        configuration.ignoresViewportScaleLimits = true
        
        super.init(configuration: configuration, settings: settings, dark: dark)
        isOpaque = false
        scrollView.keyboardDismissMode = .none
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.clipsToBounds = false
        scrollView.indicatorStyle = dark && settings.dark ? .white : .default

        let background = UIColor
            .secondarySystemBackground
            .resolvedColor(with: .init(userInterfaceStyle: dark ? .dark : .light))
        
        underPageBackgroundColor = background
        
        if !dark {
            publisher(for: \.themeColor)
                .sink { [weak self] theme in
                    guard
                        dark,
                        settings.dark,
                        let color = theme
                    else {
                        self?.underPageBackgroundColor = background
                        return
                    }
                    var alpha = CGFloat()
                    color.getRed(nil, green: nil, blue: nil, alpha: &alpha)
                    self?.underPageBackgroundColor = alpha == 0 ? background : color
                }
                .store(in: &subs)
        }
    }
    
    deinit {
        scrollView.delegate = nil
        print("web gone")
    }
    
    func thumbnail() async {
        let configuration = WKSnapshotConfiguration()
        configuration.afterScreenUpdates = false
        session.items[session.index(self)].thumbnail = (try? await takeSnapshot(configuration: configuration)) ?? .init()
    }
    
    @MainActor func resizeFont(size: CGFloat) async {
        _ = try? await evaluateJavaScript(Script.text(size: size))
    }
    
    override func deeplink(url: URL) {
        UIApplication.shared.open(url)
    }
    
    override func message(info: Info) {
        let index = session.index(self)
        session.items[index].info = info
        session.items[index].flow = .message
        session.objectWillChange.send()
    }
    
    override func webView(_ webView: WKWebView, didFinish: WKNavigation!) {
        super.webView(webView, didFinish: didFinish)
        isOpaque = true
    }
    
    func webView(_: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
        isOpaque = false
        UIApplication.shared.hide()
    }

    func webView(_: WKWebView, createWebViewWith: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if action.sourceFrame.isMainFrame,
            (action.targetFrame == nil && action.navigationType == .other) || action.navigationType == .linkActivated {
            _ = action
                .request
                .url
                .map(load)
        }
        return nil
    }
    
    func webView(_: WKWebView, contextMenuConfigurationFor: WKContextMenuElementInfo) async -> UIContextMenuConfiguration? {
        .init(identifier: nil, previewProvider: nil, actionProvider: { elements in
            var elements = elements
                .filter {
                    guard let name = ($0 as? UIAction)?.identifier.rawValue else { return true }
                    return !(name.hasSuffix("Open") || name.hasSuffix("List"))
                }
            
            if let url = contextMenuConfigurationFor
                .linkURL {
//                    elements
//                        .insert(UIAction(title: NSLocalizedString("Open in new tab", comment: ""),
//                                         image: UIImage(systemName: "plus.square.on.square"))
//                        { [weak self] _ in
//                            self?.tab.send(url)
//                        }, at: 0)
                }
            return .init(title: "", children: elements)
        })
    }
    
    func webView(_: WKWebView, contextMenuForElement element: WKContextMenuElementInfo, willCommitWithAnimator: UIContextMenuInteractionCommitAnimating) {
//        if let url = element.linkURL {
//            load(url)
//        } else if let data = (willCommitWithAnimator.previewViewController?.view.subviews.first as? UIImageView)?.image?.pngData() {
//            load(data.temporal("image.png"))
//        }
    }
    
    func makeUIView(context: Context) -> Web {
        self
    }

    func updateUIView(_: Web, context: Context) {

    }
}
