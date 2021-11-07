import AppKit
import Combine
import UserNotifications

extension Preferences.General {
    final class Notifications: NSView {
        private weak var option: Preferences.Option!
        private weak var text: Text!
        private weak var badge: Image!
        private var requested = true
        private var enabled = true
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            
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
                    if self.enabled || self.requested {
                        self.window?.close()
                        NSWorkspace
                            .shared
                            .open(URL(string: "x-apple.systempreferences:com.apple.preference.notifications")!)
                    } else {
                        Task {
                            await self.request()
                        }
                    }
                }
                .store(in: &subs)
            
            let badge = Image(icon: "checkmark.circle.fill", vibrancy: false)
            badge.symbolConfiguration = .init(textStyle: .title1)
                .applying(.init(hierarchicalColor: .systemBlue))
            badge.isHidden = true
            self.badge = badge
            
            let stack = NSStackView(views: [title, text, badge, option])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.orientation = .vertical
            stack.spacing = 20
            addSubview(stack)
            
            stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
            stack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
            text.widthAnchor.constraint(lessThanOrEqualToConstant: 240).isActive = true
            
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
                requested = false
                enabled = false
            } else if settings.alertSetting == .disabled || settings.authorizationStatus == .denied {
                option.text.stringValue = "Activate notifications"
                updateNotifications(text: Copy.notifications)
                enabled = false
            } else {
                badge.isHidden = false
                option.text.stringValue = "Open Settings"
                updateNotifications(text: Copy.deactivate)
                enabled = true
            }
        }
        
        private func updateNotifications(text: String) {
            var copy = (try? AttributedString(markdown: text, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace))) ?? .init(text)
            copy.setAttributes(.init([
                .font: NSFont.preferredFont(forTextStyle: .body),
                .foregroundColor: NSColor.secondaryLabelColor]))
            self.text.attributedStringValue = .init(copy)
        }
    }
}
