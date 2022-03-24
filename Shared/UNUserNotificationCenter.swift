import UserNotifications

extension UNUserNotificationCenter {
    static var authorization: UNAuthorizationStatus {
        get async {
            await current().notificationSettings().authorizationStatus
        }
    }
    
    static func send(message: String) async {
        let settings = await current().notificationSettings()
        guard settings.authorizationStatus == .authorized else { return }
        let content = UNMutableNotificationContent()
        content.body = message
        try? await current().add(.init(identifier: UUID().uuidString, content: content, trigger: nil))
    }
    
    static func request() async {
        _ = try? await current().requestAuthorization(options: [.alert, .criticalAlert, .provisional])
    }
    
    func present(_ notification: UNNotification) async -> UNNotificationPresentationOptions {
        let delivered = await deliveredNotifications()
        removeDeliveredNotifications(withIdentifiers: delivered
                                        .map(\.request.identifier)
                                        .filter { $0 != notification.request.identifier })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.removeAllDeliveredNotifications()
        }
        
        return notification.request.content.userInfo["aps"] == nil ? .banner : []
    }
}
