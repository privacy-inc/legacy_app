import AppKit

final class Shortcut: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .init(origin: .zero, size: .init(width: 320, height: 500)))
        
        let forget = Forget()
        forget.frame.origin.x = 55
        addSubview(forget)
    }
}
