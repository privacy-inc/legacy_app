import Foundation
import UserNotifications
import Specs

extension Store {
    enum Item: String, CaseIterable {
        case
        plus = "incognit.plus"
        
        func purchased(active: Bool) async {
            if active {
                Defaults.isPremium = true
                await UNUserNotificationCenter.send(message: "Privacy + purchase successful!")
            } else {
                Defaults.isPremium = false
            }
        }
    }
}
