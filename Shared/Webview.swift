import WebKit
import Combine
import Specs

class Webview: WKWebView, WKNavigationDelegate, WKUIDelegate {
    final let history: UInt16
    private var subs = Set<AnyCancellable>()
    private let settings: Specs.Settings.Configuration
    
    required init?(coder: NSCoder) { nil }
    @MainActor init(configuration: WKWebViewConfiguration, history: UInt16, settings: Specs.Settings.Configuration, dark: Bool) {
        self.history = history
        self.settings = settings
        
        configuration.suppressesIncrementalRendering = false
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = settings.popups && settings.javascript
        configuration.preferences.isFraudulentWebsiteWarningEnabled = !settings.http
        configuration.defaultWebpagePreferences.allowsContentJavaScript = settings.popups && settings.javascript
        configuration.websiteDataStore = .nonPersistent()
        configuration.userContentController.addUserScript(.init(source: Script.favicon.script, injectionTime: .atDocumentStart, forMainFrameOnly: true))
        configuration.userContentController.addUserScript(.init(source: settings.scripts, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
        
        if dark && settings.dark {
            configuration.userContentController.addUserScript(.init(source: Script.dark.script, injectionTime: .atDocumentStart, forMainFrameOnly: true))
        }
        
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
    
    func error(url: URL?, description: String) {
        Task
            .detached(priority: .utility) { [weak self] in
                guard let self = self else { return }
                await cloud.update(url: self.url ?? URL(string: "about:blank")!, history: self.history)
                await cloud.update(title: description, history: self.history)
            }
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
    
    final func webView(_: WKWebView, respondTo: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        settings.http
        ? (.useCredential, respondTo.protectionSpace.serverTrust.map(URLCredential.init(trust:)))
        : (.performDefaultHandling, nil)
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
        Task {
            guard
                let access = await cloud.model.history.first(where: { $0.id == history })?.website.access,
                await favicon.request(for: access),
                let url = try? await (evaluateJavaScript(Script.favicon.method)) as? String
            else { return }
            print(url)
            await favicon.received(url: url, for: access)
        }
        
        if !settings.timers {
            evaluateJavaScript(Script.unpromise.script)
        }
    }
    
    final func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences) async -> (WKNavigationActionPolicy, WKWebpagePreferences) {
        switch await cloud.policy(history: history, url: decidePolicyFor.request.url!) {
        case .allow:
            print("allow \(decidePolicyFor.request.url!)")
            preferences.allowsContentJavaScript = settings.javascript
            if #available(macOS 12, iOS 14.5, *), decidePolicyFor.shouldPerformDownload {
                return (.download, preferences)
            } else {
                return (.allow, preferences)
            }
        case .external:
            print("external \(decidePolicyFor.request.url!)")
            external(decidePolicyFor.request.url!)
            return (.cancel, preferences)
        case .ignore:
            decidePolicyFor
                .targetFrame
                .map(\.isMainFrame)
                .map {
                    guard $0 else { return }
                    error(url: decidePolicyFor.request.url!, description: "There was an error")
                }
            return (.cancel, preferences)
        case .block:
            decidePolicyFor
                .targetFrame
                .map(\.isMainFrame)
                .map {
                    guard $0 else { return }
                    error(url: decidePolicyFor.request.url!, description: "Blocked")
                }
            return (.cancel, preferences)
        }
    }
    
    final func webView(_: WKWebView, decidePolicyFor: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        decidePolicyFor.canShowMIMEType
        ? .allow
        : .download
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
