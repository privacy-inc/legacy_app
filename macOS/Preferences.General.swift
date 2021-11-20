import AppKit
import Combine
import UserNotifications

extension Preferences {
    final class General: NSTabViewItem {
        private weak var option: Preferences.Option!
        private weak var text: Text!
        private weak var badge: Image!
        private var requested = false
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init(identifier: "")
            label = "General"
            
            let title = Text(vibrancy: true)
            title.textColor = .labelColor
            title.font = .preferredFont(forTextStyle: .headline)
            title.stringValue = "Notifications"
            
            let text = Text(vibrancy: true)
            text.textColor = .secondaryLabelColor
            text.font = .preferredFont(forTextStyle: .callout)
            self.text = text
            
            let option = Preferences.Option(title: "", symbol: "app.badge")
            self.option = option
            option
                .click
                .sink { [weak self] in
                    guard let self = self else { return }
                    if self.requested {
                        self.view?.window?.close()
                        NSWorkspace
                            .shared
                            .open(URL(string: "x-apple.systempreferences:com.apple.preference.notifications")!)
                    } else {
                        Task {
                            await self.request()
                        }
                    }
                    self.requested = true
                }
                .store(in: &subs)
            
            let badge = Image(icon: "checkmark.circle.fill")
            badge.symbolConfiguration = .init(textStyle: .title1)
                .applying(.init(hierarchicalColor: .systemBlue))
            badge.isHidden = true
            self.badge = badge
            
            let stack = NSStackView(views: [title, text, badge, option])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.orientation = .vertical
            stack.spacing = 20
            view!.addSubview(stack)
            
            stack.topAnchor.constraint(equalTo: view!.topAnchor, constant: 30).isActive = true
            stack.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
            
            text.widthAnchor.constraint(lessThanOrEqualToConstant: 260).isActive = true
            
            Task {
                await checkNotifications()
            }
        }
        
        @MainActor private func request() async {
            _ = await UNUserNotificationCenter.request()
            requested = true
            await self.checkNotifications()
        }
        
        @MainActor private func checkNotifications() async {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            if settings.authorizationStatus == .notDetermined {
                option.text.stringValue = "Activate notifications"
                updateNotifications(text: Copy.notifications)
            } else if settings.alertSetting == .disabled || settings.authorizationStatus == .denied {
                option.text.stringValue = "Open Settings"
                updateNotifications(text: Copy.notifications)
                requested = true
            } else {
                badge.isHidden = false
                option.text.stringValue = "Open Settings"
                updateNotifications(text: Copy.deactivate)
                requested = true
            }
        }
        
        private func updateNotifications(text: String) {
            self.text.attributedStringValue = .with(markdown: text, attributes: [
                .font: NSFont.preferredFont(forTextStyle: .body),
                .foregroundColor: NSColor.secondaryLabelColor])
        }
    }
}
