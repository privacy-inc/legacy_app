import AppKit
import UserNotifications

extension Menu {
    final class CopyLink: NSMenuItem {
        private let url: URL
        
        required init(coder: NSCoder) { fatalError() }
        init(url: URL, icon: Bool, shortcut: Bool) {
            self.url = url
            
            super.init(title: "Copy Link", action: nil, keyEquivalent: shortcut ? "C" : "")
            target = self
            action = #selector(share)
            if icon {
                image = .init(systemSymbolName: "link", accessibilityDescription: nil)
            }
        }
        
        @objc private func share() {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(url.absoluteString, forType: .string)
            
            Task
                .detached(priority: .utility) {
                    await UNUserNotificationCenter.send(message: "Link URL copied")
                }
        }
    }
}
