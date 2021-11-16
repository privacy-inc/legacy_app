import WebKit
import Combine
import Specs

class Webview: WKWebView, WKNavigationDelegate, WKUIDelegate {
    final var subs = Set<AnyCancellable>()
    final let history: UInt16
    final let progress = PassthroughSubject<Double, Never>()
    private let settings: Specs.Settings.Configuration
    
    required init?(coder: NSCoder) { nil }
    @MainActor init(configuration: WKWebViewConfiguration,
                    history: UInt16,
                    settings: Specs.Settings.Configuration,
                    dark: Bool) {
        
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
            configuration.userContentController.addUserScript(.init(source: Script.dark.script, injectionTime: .atDocumentStart, forMainFrameOnly: false))
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
        
        publisher(for: \.estimatedProgress)
            .subscribe(progress)
            .store(in: &subs)
        
        Task {
            guard
                let rules = try? await WKContentRuleListStore.default().compileContentRuleList(
                    forIdentifier: "rules",
                    encodedContentRuleList: settings.blockers(dark: dark))
            else { return }
            configuration.userContentController.add(rules)
        }
    }
    
    func external(_ url: URL) {
        
    }
    
    func error(error: Err) {

    }
    
    func webView(_: WKWebView, didFinish: WKNavigation!) {
        Task {
            guard
                let access = await cloud.website(history: history)?.access,
                await favicon.request(for: access),
                let url = try? await (evaluateJavaScript(Script.favicon.method)) as? String
            else { return }
            await favicon.received(url: url, for: access)
        }
        
        if !settings.timers {
            evaluateJavaScript(Script.unpromise.script)
        }
    }
    
    @MainActor final func access() async {
        await cloud
            .website(history: history)
            .map {
                load($0.access)
            }
    }
    
    final func clear() {
        stopLoading()
        uiDelegate = nil
        navigationDelegate = nil
        
        configuration.userContentController.removeScriptMessageHandler(forName: Script.location.method)
    }
    
    final func load(_ url: URL) {
        load(.init(url: url))
    }
        
    final func error(url: URL, description: String) {
        progress.send(1)
        error(error: .init(url: url, description: description))
        
        Task
            .detached(priority: .utility) { [weak self] in
                guard let history = self?.history else { return }
                await cloud.update(url: url, history: history)
                await cloud.update(title: description, history: history)
            }
    }
    
    @MainActor final func load(_ access: AccessType) {
        switch access {
        case let remote as Access.Remote:
            remote
                .url
                .map {
                    load($0)
                }
        case let other as Access.Other:
            other
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
                } (withError._userInfo as? [String : Any])
                ?? URL(string: "about:blank")!, description: withError.localizedDescription)
    }
    
    final func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences) async -> (WKNavigationActionPolicy, WKWebpagePreferences) {
        switch await cloud.policy(history: history, url: decidePolicyFor.request.url!) {
        case .allow:
            if decidePolicyFor.shouldPerformDownload {
                return (.download, preferences)
            } else {
#if DEBUG
                print("allow \(decidePolicyFor.request.url!)")
#endif
                preferences.allowsContentJavaScript = settings.javascript
                return (.allow, preferences)
            }
        case .external:
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
    
    final func webView(_: WKWebView, decidePolicyFor: WKNavigationAction) async -> WKNavigationActionPolicy {
        decidePolicyFor.shouldPerformDownload ? .download : .allow
    }
    
    final func webView(_: WKWebView, decidePolicyFor: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        guard
            let response = decidePolicyFor.response as? HTTPURLResponse,
            let contentType = response.value(forHTTPHeaderField: "Content-Type"),
            contentType.range(of: "attachment", options: .caseInsensitive) != nil
        else {
            return decidePolicyFor.canShowMIMEType ? .allow : .download
        }
        return .download
    }
    
    final func webView(_: WKWebView, navigationAction: WKNavigationAction, didBecome: WKDownload) {
        didBecome.delegate = self
    }
    
    final func webView(_: WKWebView, navigationResponse: WKNavigationResponse, didBecome: WKDownload) {
        didBecome.delegate = self
    }
    
    final func download(_ download: WKDownload, didFailWithError: Error, resumeData: Data?) {
        error(url: download.originalRequest?.url ?? URL(string: "about:blank")!,
              description: (didFailWithError as NSError).localizedDescription)
    }
    
    @MainActor final class func clear() async {
        URLCache.shared.removeAllCachedResponses()
        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
        await clear(store: .default())
        await clear(store: .nonPersistent())
    }
    
    @MainActor private class func clear(store: WKWebsiteDataStore) async {
        for record in await store.dataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) {
            await store.removeData(ofTypes: record.dataTypes, for: [record])
        }
        await store.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: .distantPast)
    }
}
