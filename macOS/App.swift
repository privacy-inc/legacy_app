import AppKit
import StoreKit
import UserNotifications
import Specs

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate, UNUserNotificationCenterDelegate {
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
        Window.new()
    }
    
    func applicationDidFinishLaunching(_: Notification) {
        Task {
            switch Defaults.action {
            case .rate:
                SKStoreReviewController.requestReview()
            case .froob:
                (NSApp.anyWindow() ?? Froob())
                    .makeKeyAndOrderFront(nil)
            case .none:
                break
            }
            
            await cloud.migrate()
        }

        registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
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
            Window.new()
        }
        return false
    }
    
    func application(_ app: NSApplication, open: [URL]) {
        open
            .forEach(app.open(url:))
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        await center.present(notification)
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent: UNNotification) async -> UNNotificationPresentationOptions {
//        await center.present(willPresent)
//    }
    
    @objc override func orderFrontStandardAboutPanel(_ sender: Any?) {
        (anyWindow() ?? About())
            .makeKeyAndOrderFront(nil)
    }

    @objc private func handle(_ event: NSAppleEventDescriptor, _: NSAppleEventDescriptor) {
        event
            .paramDescriptor(forKeyword: keyDirectObject)
            .flatMap(\.stringValue?.removingPercentEncoding)
            .flatMap(URL.init(string:))
            .map(NSApp.open(url:))
    }
}
