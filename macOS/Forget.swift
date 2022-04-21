import AppKit
import Combine
import UserNotifications

final class Forget: NSView {
    private var subs = Set<AnyCancellable>()

    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .init(origin: .zero, size: .init(width: 260, height: 300)))
        
        let text = Text(vibrancy: true)
        text.stringValue = "Forget history, cache, trackers and cookies."
        text.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title2).pointSize, weight: .medium)
        text.textColor = .labelColor
        text.alignment = .left
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let image = NSImageView(image: .init(systemSymbolName: "flame.fill", accessibilityDescription: nil) ?? .init())
        image.symbolConfiguration = .init(pointSize: 60, weight: .light)
            .applying(.init(hierarchicalColor: .init(named: "Dawn")!))
        
        let control = Control.Prominent("Forget")
        control
            .click
            .sink {
                NSApp.closeAll()
                
                Task
                    .detached(priority: .utility) {
                        await Webview.clear()
                        await favicon.clear()
                        await cloud.forget()
                        await UNUserNotificationCenter.send(message: "Forgot everything!")
                    }
            }
            .store(in: &subs)
        
        
        
        let stack = NSStackView(views: [text, image, control])
        stack.orientation = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
    }
}
