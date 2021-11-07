import AppKit
import Combine
import UserNotifications

extension Preferences {
    final class Notifications: NSTabViewItem {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init(identifier: "Notifications")
            label = "Notifications"
            
            let text = Text(vibrancy: true)
            text.textColor = .secondaryLabelColor
            text.font = .preferredFont(forTextStyle: .callout)
            text.stringValue = """
Show notifications of important events.
Avocado will never send you Push Notifications, and all notifications will appear only while you are using the app.

Your privacy is respected at all times.
"""
            view!.addSubview(text)
            
            let option = Option(title: "Enable notifications", symbol: "app.badge")
            option.state = .hidden
            option
                .click
                .sink {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { success, error in
                        if success {
                            DispatchQueue.main.async { [weak self] in
                                self?.view?.window?.close()
                            }
                        }
                    }
                }
                .store(in: &subs)
            view!.addSubview(option)
            
            let check = Image(icon: "checkmark.circle.fill")
            check.symbolConfiguration = .init(textStyle: .title1)
            check.contentTintColor = .labelColor
            check.isHidden = true
            view!.addSubview(check)
            
            option.bottomAnchor.constraint(equalTo: text.topAnchor, constant: -20).isActive = true
            option.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
            
            check.centerXAnchor.constraint(equalTo: option.centerXAnchor).isActive = true
            check.centerYAnchor.constraint(equalTo: option.centerYAnchor).isActive = true
            
            text.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
            text.bottomAnchor.constraint(equalTo: view!.bottomAnchor, constant: -20).isActive = true
            text.widthAnchor.constraint(equalToConstant: 300).isActive = true
            
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    if settings.alertSetting == .enabled && settings.authorizationStatus == .authorized {
                        check.isHidden = false
                    } else {
                        option.state = .on
                    }
                }
            }
        }
    }
}
