import AppKit

final class Image: NSImageView {
    required init?(coder: NSCoder) { nil }
    convenience init(icon: String) {
        self.init()
        image = .init(systemSymbolName: icon, accessibilityDescription: nil)
    }

    convenience init(named: String) {
        self.init()
        image = .init(named: named)
    }
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func hitTest(_: NSPoint) -> NSView? {
        nil
    }
}
