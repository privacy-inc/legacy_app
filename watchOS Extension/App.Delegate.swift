import WatchKit

extension App {
    final class Delegate: NSObject, WKExtensionDelegate {
        func applicationDidFinishLaunching() {
            WKExtension.shared().registerForRemoteNotifications()
        }
        
        func didReceiveRemoteNotification(_: [AnyHashable : Any]) async -> WKBackgroundFetchResult {
            await cloud.notified ? .newData : .noData
        }
        
        func didRegisterForRemoteNotifications(withDeviceToken: Data) {
            
        }
        
        func didFailToRegisterForRemoteNotificationsWithError(_: Error) {
            
        }
    }
}
