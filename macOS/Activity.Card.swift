import AppKit

extension Activity {
    final class Card: NSView {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            layer = Layer()
            wantsLayer = true
            shadow = NSShadow()
            shadow!.shadowColor = .init(white: 0, alpha: 0.1)
            layer!.backgroundColor = NSColor.controlBackgroundColor.cgColor
            layer!.cornerCurve = .continuous
            layer!.cornerRadius = 14
            layer!.shadowOffset = .zero
            layer!.shadowRadius = 5
            
            widthAnchor.constraint(equalToConstant: 400).isActive = true
        }
        
        override func hitTest(_: NSPoint) -> NSView? {
            nil
        }
    }
}
