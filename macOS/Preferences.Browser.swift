import AppKit
import Combine
import UserNotifications

extension Preferences {
    final class Browser: NSTabViewItem {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init(identifier: "")
            label = "Browser"
            
            let title = Text(vibrancy: true)
            title.textColor = .labelColor
            title.font = .preferredFont(forTextStyle: .headline)
            title.stringValue = "Default Browser"
            
            let text = Text(vibrancy: true)
            text.textColor = .secondaryLabelColor
            text.font = .preferredFont(forTextStyle: .callout)
            text.attributedStringValue = .init(.with(markdown: Copy.browser, attributes: .init([
                .font: NSFont.preferredFont(forTextStyle: .body),
                .foregroundColor: NSColor.secondaryLabelColor])))
            
            let option = Preferences.Option(title: "Make default Browser", symbol: "magnifyingglass")
            option
                .click
                .sink { [weak self] in
                    LSSetDefaultHandlerForURLScheme(URL.Scheme.http.rawValue as CFString, "incognit" as CFString)
                    LSSetDefaultHandlerForURLScheme(URL.Scheme.https.rawValue as CFString, "incognit" as CFString)
                    self?.view?.window?.close()
                    
                    Task {
                        await UNUserNotificationCenter.send(message: "Made default Browser")
                    }
                }
                .store(in: &subs)
            
            let badge = Image(icon: "checkmark.circle.fill", vibrancy: false)
            badge.symbolConfiguration = .init(textStyle: .title1)
                .applying(.init(hierarchicalColor: .systemBlue))
            badge.isHidden = true
            
            let stack = NSStackView(views: [title, text, badge, option])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.orientation = .vertical
            stack.spacing = 20
            view!.addSubview(stack)
            
            if isDefault {
                badge.isHidden = false
                text.isHidden = true
                option.isHidden = true
            }
            
            stack.topAnchor.constraint(equalTo: view!.topAnchor, constant: 30).isActive = true
            stack.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
            
            text.widthAnchor.constraint(lessThanOrEqualToConstant: 260).isActive = true
        }
        
        private var isDefault: Bool {
            NSWorkspace
                .shared
                .urlForApplication(toOpen: URL(string: URL.Scheme.http.rawValue + "://")!)
                .map {
                    $0.lastPathComponent == Bundle.main.bundleURL.lastPathComponent
                }
                ?? false
        }
    }
}
