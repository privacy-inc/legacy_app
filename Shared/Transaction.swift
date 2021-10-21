import StoreKit
import UserNotifications
import Specs

extension Transaction {
    func process() async {
        guard let item = Store.Item(rawValue: productID) else { return }
        switch item {
        case .plus:
            if revocationDate == nil {
                Defaults.isPremium = true
                await UNUserNotificationCenter.send(message: "Privacy + purchase successful!")
            } else {
                Defaults.isPremium = false
            }
        }
        await finish()
    }
}
