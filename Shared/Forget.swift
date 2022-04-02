import Foundation
import UserNotifications

enum Forget {
    static func cache() {
        Task
            .detached(priority: .utility) {
                await Webview.clear()
                await UNUserNotificationCenter.send(message: "Forgot cache!")
            }
    }
    
    static func history() {
//        Task
//            .detached(priority: .utility) {
//                await cloud.forgetHistory()
//                await favicon.clear()
//                await UNUserNotificationCenter.send(message: "Forgot history!")
//            }
    }
    
    static func activity() {
//        Task
//            .detached(priority: .utility) {
//                await cloud.forgetActivity()
//                await UNUserNotificationCenter.send(message: "Forgot activity!")
//            }
    }
    
    static func everything() {
        Task
            .detached(priority: .utility) {
                await Webview.clear()
                await favicon.clear()
                await cloud.forget()
                await UNUserNotificationCenter.send(message: "Forgot everything!")
            }
    }
}
