import StoreKit
import Combine

extension App {
    final class Delegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, SKPaymentTransactionObserver {
        let store = PassthroughSubject<SKProduct, Never>()
        
        func application(_ application: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            application.registerForRemoteNotifications()
            UNUserNotificationCenter.current().delegate = self
            SKPaymentQueue.default().add(self)
            return true
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent: UNNotification) async -> UNNotificationPresentationOptions {
            await center.present(willPresent)
        }
        
        func application(_: UIApplication, didReceiveRemoteNotification: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
            await cloud.notified ? .newData : .noData
        }
        
        func paymentQueue(_: SKPaymentQueue, shouldAddStorePayment: SKPayment, for product: SKProduct) -> Bool {
            store.send(product)
            return false
        }
        
        func paymentQueue(_: SKPaymentQueue, updatedTransactions: [SKPaymentTransaction]) {
    
        }
    }
}
