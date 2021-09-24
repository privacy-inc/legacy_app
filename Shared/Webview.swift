import WebKit
import Combine
import Sleuth

class Webview: WKWebView, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    final var subs = Set<AnyCancellable>()
    final let id: UUID
    final let browse: Int
    final let settings: Sleuth.Settings
    final let session: Session
    
    required init?(coder: NSCoder) { nil }
    init(configuration: WKWebViewConfiguration, session: Session, id: UUID, browse: Int, settings: Sleuth.Settings) {
        self.session = session
        self.id = id
        self.browse = browse
        self.settings = settings
        
        configuration.suppressesIncrementalRendering = false
        configuration.allowsAirPlayForMediaPlayback = true
#warning("Add a setting for this")
        configuration.mediaTypesRequiringUserActionForPlayback = .all
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = settings.popups && settings.javascript
        configuration.preferences.isFraudulentWebsiteWarningEnabled = !settings.http
        configuration.defaultWebpagePreferences.allowsContentJavaScript = settings.popups && settings.javascript
        configuration.websiteDataStore = .nonPersistent()
        configuration.userContentController.addUserScript(.init(source: settings.start, injectionTime: .atDocumentStart, forMainFrameOnly: true))
        configuration.userContentController.addUserScript(.init(source: settings.end, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
        
    #if DEBUG
        configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
    #endif

        WKContentRuleListStore
            .default()!
            .compileContentRuleList(forIdentifier: "rules", encodedContentRuleList: settings.rules) { rules, _ in
                rules.map(configuration.userContentController.add)
            }
        
        super.init(frame: .zero, configuration: configuration)
        navigationDelegate = self
        uiDelegate = self
        allowsBackForwardNavigationGestures = true
        
        Script
            .Message
            .allCases
            .map(\.rawValue)
            .forEach {
                configuration.userContentController.add(self, name: $0)
            }
        
        publisher(for: \.estimatedProgress, options: .new)
            .removeDuplicates()
            .sink {
                session.tab.update(id, progress: $0)
            }
            .store(in: &subs)

        publisher(for: \.isLoading, options: .new)
            .removeDuplicates()
            .sink {
                session.tab.update(id, loading: $0)
            }
            .store(in: &subs)

        publisher(for: \.canGoForward, options: .new)
            .removeDuplicates()
            .sink {
                session.tab.update(id, forward: $0)
            }
            .store(in: &subs)

        publisher(for: \.canGoBack, options: .new)
            .removeDuplicates()
            .sink {
                session.tab.update(id, back: $0)
            }
            .store(in: &subs)
        
        publisher(for: \.title, options: .new)
            .compactMap {
                $0
            }
            .filter {
                !$0.isEmpty
            }
            .removeDuplicates()
            .sink {
                cloud.update(browse, title: $0)
            }
            .store(in: &subs)

        publisher(for: \.url, options: .new)
            .compactMap {
                $0
            }
            .removeDuplicates()
            .sink {
                cloud.update(browse, url: $0)
            }
            .store(in: &subs)
        
        load(cloud.archive.value.page(browse).access)
    }
    
    func external(_ url: URL) {
        
    }
    
    func userContentController(_: WKUserContentController, didReceive: WKScriptMessage) {
        switch Script.Message(rawValue: didReceive.name) {
        case .favicon:
            (didReceive.body as? String)
                .map {
                    favicon
                        .save(domain: cloud.archive.value.page(browse).access.short, url: $0)
                }
        default:
            break
        }
    }
    
    final func clear() {
        stopLoading()
        
        Script
            .Message
            .allCases
            .map(\.rawValue)
            .forEach {
                configuration.userContentController.removeScriptMessageHandler(forName: $0)
            }
        
        uiDelegate = nil
        navigationDelegate = nil
    }
    
    final func load(_ access: Page.Access) {
        switch access {
        case let .remote(remote):
            remote
                .url
                .map(load)
        case let .local(local):
            local
                .open {
                    loadFileURL($0, allowingReadAccessTo: $1)
                }
        case let .deeplink(deeplink):
            deeplink
                .url
                .map(load)
        case let .embed(embed):
            embed
                .url
                .map(load)
        }
    }
    
    final func load(_ url: URL) {
        load(.init(url: url))
    }
    
    final func error(url: URL?, description: String) {
        let url = url ?? self.url ?? URL(string: "about:blank")!
        cloud.update(browse, url: url)
        cloud.update(browse, title: description)
        cloud.activity()
        session.tab.error(id, .init(url: url.absoluteString, description: description))
        session.tab.update(id, progress: 1)
    }
    
    final func webView(_: WKWebView, didReceive: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard settings.http else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        completionHandler(.useCredential, didReceive.protectionSpace.serverTrust.map(URLCredential.init(trust:)))
    }
    
    final func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
        guard
            (withError as NSError).code != NSURLErrorCancelled,
            (withError as NSError).code != frame_load_interrupted
        else { return }
        
        error(url: (withError as? URLError)
                .flatMap(\.failingURL)
                ?? url
                ?? {
                    $0?["NSErrorFailingURLKey"] as? URL
                } (withError._userInfo as? [String : Any]), description: withError.localizedDescription)
    }
    
    final func webView(_: WKWebView, didFinish: WKNavigation!) {
        session.tab.update(id, progress: 1)
        cloud.activity()
        
        if case let .remote(remote) = cloud.archive.value.page(browse).access,
           favicon.needs(domain: remote.domain) {
            evaluateJavaScript("_privacy_incognit_favicon();")
        }
        
        if !settings.timers {
            evaluateJavaScript("Promise = null;")
        }
    }
    
    final func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        switch cloud.policy(decidePolicyFor.request.url!) {
        case .allow:
            print("allow \(decidePolicyFor.request.url!)")
            preferences.allowsContentJavaScript = settings.javascript
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
                    session.tab.error(id, .init(url: decidePolicyFor.request.url!.absoluteString, description: "There was an error"))
                }
        case .block:
//            print("block \(decidePolicyFor.request.url!)")
            decisionHandler(.cancel, preferences)
            decidePolicyFor
                .targetFrame
                .map(\.isMainFrame)
                .map {
                    guard $0 else { return }
                    session.tab.error(id, .init(url: decidePolicyFor.request.url!.absoluteString, description: "Blocked"))
                }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
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

private let url_cant_be_shown = 101
private let frame_load_interrupted = 102
