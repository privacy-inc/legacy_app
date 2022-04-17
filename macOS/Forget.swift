import AppKit
import Combine
import UserNotifications

final class Forget: NSView {
    private var subs = Set<AnyCancellable>()

    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .init(origin: .zero, size: .init(width: 200, height: 160)))
        
        let control = Control.Label(title: "Forget", symbol: "flame.fill")
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
        
        let text = Text(vibrancy: true)
        text.stringValue = "Clear history, cache,\ntrackers and cookies"
        text.font = .preferredFont(forTextStyle: .footnote)
        text.textColor = .secondaryLabelColor
        text.alignment = .left
        addSubview(text)
        
        control.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        control.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        control.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        text.topAnchor.constraint(equalTo: control.bottomAnchor, constant: 10).isActive = true
        text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
