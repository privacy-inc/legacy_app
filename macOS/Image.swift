import AppKit

final class Image: NSImageView {
    private let vibrancy: Bool
    
    required init?(coder: NSCoder) { nil }
    convenience init(icon: String, vibrancy: Bool = true) {
        self.init(vibrancy: vibrancy)
        image = .init(systemSymbolName: icon, accessibilityDescription: nil)
    }

    convenience init(named: String, vibrancy: Bool) {
        self.init(vibrancy: vibrancy)
        image = .init(named: named)
    }
    
    init(vibrancy: Bool) {
        self.vibrancy = vibrancy
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override var allowsVibrancy: Bool {
        vibrancy
    }
    
    override func hitTest(_: NSPoint) -> NSView? {
        nil
    }
}
