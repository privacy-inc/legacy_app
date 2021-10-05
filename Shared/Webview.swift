import WebKit
import Combine
import Specs

class Webview: WKWebView, WKNavigationDelegate, WKUIDelegate {
    final let history: UInt16
    final var subs = Set<AnyCancellable>()
    private let settings: Specs.Settings.Configuration
    
    required init?(coder: NSCoder) { nil }
    @MainActor init(configuration: WKWebViewConfiguration, history: UInt16, settings: Specs.Settings.Configuration) {
        self.history = history
        self.settings = settings
        
        configuration.suppressesIncrementalRendering = false
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = settings.popups && settings.javascript
        configuration.preferences.isFraudulentWebsiteWarningEnabled = !settings.http
        configuration.defaultWebpagePreferences.allowsContentJavaScript = settings.popups && settings.javascript
        configuration.websiteDataStore = .nonPersistent()
        configuration.userContentController.addUserScript(.init(source: Script.favicon.script, injectionTime: .atDocumentStart, forMainFrameOnly: true))
        
        let scripts = settings.scripts
        configuration.userContentController.addUserScript(.init(source: scripts.start, injectionTime: .atDocumentStart, forMainFrameOnly: true))
        configuration.userContentController.addUserScript(.init(source: scripts.end, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
        
        switch settings.autoplay {
        case .none:
            configuration.mediaTypesRequiringUserActionForPlayback = .all
        case .audio:
            configuration.mediaTypesRequiringUserActionForPlayback = .video
        case .video:
            configuration.mediaTypesRequiringUserActionForPlayback = .audio
        case .all:
            configuration.mediaTypesRequiringUserActionForPlayback = []
        }
        
    #if DEBUG
        configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
    #endif

        WKContentRuleListStore
            .default()!
            .compileContentRuleList(forIdentifier: "rules", encodedContentRuleList: settings.blockers) { rules, _ in
                rules.map(configuration.userContentController.add)
            }

        super.init(frame: .zero, configuration: configuration)
        navigationDelegate = self
        uiDelegate = self
        allowsBackForwardNavigationGestures = true
        
        publisher(for: \.title)
            .compactMap {
                $0
            }
            .removeDuplicates()
            .sink { title in
                Task
                    .detached(priority: .utility) {
                        await cloud.update(title: title, history: history)
                    }
            }
            .store(in: &subs)

        publisher(for: \.url)
            .compactMap {
                $0
            }
            .removeDuplicates()
            .sink { url in
                Task
                    .detached(priority: .utility) {
                        await cloud.update(url: url, history: history)
                    }
            }
            .store(in: &subs)
    }
    
    func external(_ url: URL) {
        
    }
    
    final func clear() {
        stopLoading()
        uiDelegate = nil
        navigationDelegate = nil
    }
    
    final func load(_ url: URL) {
        load(.init(url: url))
    }
    
    @MainActor final func load(_ access: AccessType) {
        switch access {
        case let url as AccessURL:
            url
                .url
                .map {
                    load($0)
                }
        case let local as Access.Local:
            local
                .open { file, directory in
                    loadFileURL(file, allowingReadAccessTo: directory)
                }
        default:
            break
        }
    }
    
    final func error(url: URL?, description: String) {
        let url = url ?? self.url ?? URL(string: "about:blank")!
//        cloud.update(browse, url: url)
//        cloud.update(browse, title: description)
//        cloud.activity()
//        session.tab.error(id, .init(url: url.absoluteString, description: description))
//        session.tab.update(id, progress: 1)
    }
    
    final func webView(_: WKWebView, didReceive: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        guard settings.http else {
            completionHandler(.performDefaultHandling, nil)
//            return
//        }
//        completionHandler(.useCredential, didReceive.protectionSpace.serverTrust.map(URLCredential.init(trust:)))
    }
    
    final func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
        guard
            (withError as NSError).code != NSURLErrorCancelled,
            (withError as NSError).code != Code.frameLoadInterrupted.rawValue
        else { return }
        
        error(url: (withError as? URLError)
                .flatMap(\.failingURL)
                ?? url
                ?? {
                    $0?["NSErrorFailingURLKey"] as? URL
                } (withError._userInfo as? [String : Any]), description: withError.localizedDescription)
    }
    
    final func webView(_: WKWebView, didFinish: WKNavigation!) {
//        session.tab.update(id, progress: 1)
//        cloud.activity()
//
        
        Task {
            guard
                let access = await cloud.model.history.first(where: { $0.id == history })?.website.access,
                await favicon.request(for: access),
                let url = try? await (evaluateJavaScript(Script.favicon.method)) as? String
            else { return }
            print(url)
            await favicon.received(url: url, for: access)
        }
//
//        if !settings.timers {
//            evaluateJavaScript("Promise = null;")
//        }
    }
    
//    final func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences) async -> (WKNavigationActionPolicy, WKWebpagePreferences) {
//        switch cloud.policy(history: history, url: decidePolicyFor.request.url!) {
//        case .allow:
//            print("allow \(decidePolicyFor.request.url!)")
//            preferences.allowsContentJavaScript = settings.javascript
//            if #available(macOS 12, iOS 14.5, *), decidePolicyFor.shouldPerformDownload {
//                decisionHandler(.download, preferences)
//            } else {
//                decisionHandler(.allow, preferences)
//            }
//        }
//    }
    
    final func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        
        
        
        decisionHandler(.allow, preferences)
        
        
        
        
        
        /*switch cloud.policy(decidePolicyFor.request.url!) {
        case .allow:
            print("allow \(decidePolicyFor.request.url!)")
//            preferences.allowsContentJavaScript = settings.javascript
            if #available(macOS 12, iOS 14.5, *), decidePolicyFor.shouldPerformDownload {
                decisionHandler(.download, preferences)
            } else {
                decisionHandler(.allow, preferences)
            }
        case .external:
            print("external \(decidePolicyFor.request.url!)")
            decisionHandler(.cancel, preferences)
            external(decidePolicyFor.request.url!)
        case .ignore:
//            print("ignore \(decidePolicyFor.request.url!)")
            decisionHandler(.cancel, preferences)
            decidePolicyFor
                .targetFrame
                .map(\.isMainFrame)
                .map {
                    guard $0 else { return }
//                    session.tab.error(id, .init(url: decidePolicyFor.request.url!.absoluteString, description: "There was an error"))
                }
        case .block:
//            print("block \(decidePolicyFor.request.url!)")
            decisionHandler(.cancel, preferences)
            decidePolicyFor
                .targetFrame
                .map(\.isMainFrame)
                .map {
                    guard $0 else { return }
//                    session.tab.error(id, .init(url: decidePolicyFor.request.url!.absoluteString, description: "Blocked"))
                }
        }*/
    }
    
    final func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard #available(macOS 12, iOS 14.5, *), !navigationResponse.canShowMIMEType else {
            decisionHandler(.allow)
            return
        }
        decisionHandler(.download)
    }
    
    final class func clear() {
        URLCache.shared.removeAllCachedResponses()
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
        [WKWebsiteDataStore.default(), WKWebsiteDataStore.nonPersistent()].forEach {
            $0.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) {
                $0.forEach {
                    WKWebsiteDataStore.default().removeData(ofTypes: $0.dataTypes, for: [$0]) { }
                }
            }
            $0.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: .distantPast) { }
        }
    }
}
