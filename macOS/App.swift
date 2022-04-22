import AppKit
import UserNotifications
import StoreKit
import Combine
import Specs

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    let froob = CurrentValueSubject<_, Never>(false)
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self

        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handle(_:_:)),
            forEventClass: .init(kInternetEventClass),
            andEventID: .init(kAEGetURL)
        )
    }
    
    func applicationWillFinishLaunching(_: Notification) {
        mainMenu = Menu()
    }
    
    func applicationDidFinishLaunching(_: Notification) {
        registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self

        cloud.ready.notify(queue: .main) {
            cloud.pull.send()
            
            self.newWindow()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                switch Defaults.action {
                case .rate:
                    SKStoreReviewController.requestReview()
                case .froob:
                    self.froob.value = true
                case .none:
                    break
                }
                
                Task
                    .detached {
                        _ = await UNUserNotificationCenter.request()
                        await store.launch()
                    }
            }
        }
    }
    
    func applicationDidBecomeActive(_: Notification) {
        cloud.pull.send()
    }
    
    func application(_: NSApplication, didReceiveRemoteNotification: [String : Any]) {
        cloud.pull.send()
    }
    
    func applicationShouldHandleReopen(_: NSApplication, hasVisibleWindows: Bool) -> Bool {
        if hasVisibleWindows {
            windows
                .filter(\.isMiniaturized)
                .forEach {
                    $0.deminiaturize(nil)
                }
        } else {
            newWindow()
        }
        return false
    }
    
    func application(_ app: NSApplication, open: [URL]) {
        launch(urls: open)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        await center.present(notification)
    }
    
    func application(_: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken: Data) {
        
    }
    
    func application(_: NSApplication, didFailToRegisterForRemoteNotificationsWithError: Error) {
        
    }
    
    func showLearn(with: Learn.Item) {
        let window = anyWindow() ?? Learn()
        window.item.send(with)
        window.makeKeyAndOrderFront(nil)
    }
    
    @objc override func orderFrontStandardAboutPanel(_ sender: Any?) {
        (anyWindow() ?? About())
            .makeKeyAndOrderFront(nil)
    }
    
    @objc func showPreferencesWindow(_ sender: Any?) {
        (anyWindow() ?? Preferences())
            .makeKeyAndOrderFront(nil)
    }
    
    @objc func showPolicy() {
        showLearn(with: .policy)
    }
    
    @objc func showTerms() {
        showLearn(with: .terms)
    }
    
    private func launch(urls: [URL]) {
        cloud.ready.notify(queue: .main) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                urls
                    .forEach {
                        NSApp.open(url: $0, change: true)
                    }
            }
        }
    }
    
    @objc private func handle(_ event: NSAppleEventDescriptor, _: NSAppleEventDescriptor) {
        event
            .paramDescriptor(forKeyword: keyDirectObject)
            .flatMap(\.stringValue?.removingPercentEncoding)
            .flatMap(URL.init(string:))
            .map {
                launch(urls: [$0])
            }
    }
}
