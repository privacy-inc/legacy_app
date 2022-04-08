import AppKit
import Combine
import UserNotifications

final class Forget: NSView {
    private var subs = Set<AnyCancellable>()

    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .init(origin: .zero, size: .init(width: 210, height: 210)))
        
        let image = NSImageView(image: .init(named: "Forget") ?? .init())
        image.translatesAutoresizingMaskIntoConstraints = false
        addSubview(image)
        
        let control = Control.Title("Forget")
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
        addSubview(control)
        
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: topAnchor, constant: 60).isActive = true
        
        control.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
        control.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        control.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
