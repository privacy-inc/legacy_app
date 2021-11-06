import AppKit
import Combine
import UserNotifications

extension Preferences {
    final class General: NSTabViewItem {
        private weak var notificationOption: Option!
        private weak var notificationText: Text!
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init(identifier: "General")
            label = "General"
            
            let notificationText = Text(vibrancy: true)
            notificationText.textColor = .secondaryLabelColor
            notificationText.font = .preferredFont(forTextStyle: .callout)
            view!.addSubview(notificationText)
            
            let notificationOption = Option(title: "")
            notificationOption
                .click
                .sink {
                    
                }
                .store(in: &subs)
            view!.addSubview(notificationOption)
            
            let check = Image(icon: "checkmark.circle.fill")
            check.symbolConfiguration = .init(textStyle: .title1)
            check.contentTintColor = .labelColor
            check.isHidden = true
            view!.addSubview(check)
            
            notificationOption.bottomAnchor.constraint(equalTo: notificationText.topAnchor, constant: -20).isActive = true
            notificationOption.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
            
            check.centerXAnchor.constraint(equalTo: option.centerXAnchor).isActive = true
            check.centerYAnchor.constraint(equalTo: option.centerYAnchor).isActive = true
            
            notificationText.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
            notificationText.bottomAnchor.constraint(equalTo: view!.bottomAnchor, constant: -20).isActive = true
            notificationText.widthAnchor.constraint(equalToConstant: 300).isActive = true
            
            Task {
                await check()
            }
        }
        
        private func check() async {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            if settings.authorizationStatus == .notDetermined {
                requested = false
                enabled = false
            } else if settings.alertSetting == .disabled {
                enabled = false
            } else {
                enabled = true
            }
        }
    }
}
