import AppKit
import StoreKit
import Specs

//let location = Location()

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate {
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
    
    func application(_: NSApplication, open: [URL]) {
//        cloud
//            .notifier
//            .notify(queue: .main) {
//                open
//                    .forEach(self.newTabWith(url:))
//            }
    }
    
    @objc override func orderFrontStandardAboutPanel(_ sender: Any?) {
        (anyWindow() ?? About())
            .makeKeyAndOrderFront(nil)
    }

    @objc private func handle(_ event: NSAppleEventDescriptor, _: NSAppleEventDescriptor) {
//        cloud
//            .notifier
//            .notify(queue: .main) {
//                event
//                    .paramDescriptor(forKeyword: keyDirectObject)
//                    .flatMap(\.stringValue?.removingPercentEncoding)
//                    .flatMap(URL.init(string:))
//                    .map(self.newTabWith(url:))
//            }
    }
}
