import AppKit

final class Separator: NSView {
    enum Mode {
        case
        horizontal,
        vertical
    }
    
    required init?(coder: NSCoder) { nil }
    init(mode: Mode) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        
        switch mode {
        case .horizontal:
            heightAnchor.constraint(equalToConstant: 1).isActive = true
        case .vertical:
            widthAnchor.constraint(equalToConstant: 1).isActive = true
        }
    }
    
    override func updateLayer() {
        layer!.backgroundColor = NSColor.separatorColor.cgColor
    }
    
    override var allowsVibrancy: Bool {
        true
    }
    
    override func hitTest(_: NSPoint) -> NSView? {
        nil
    }
}
