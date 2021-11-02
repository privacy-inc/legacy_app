import AppKit

final class Card: Control {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(layer: true)
        layer!.cornerCurve = .continuous
        layer!.cornerRadius = 12
    }
    
    override func update() {
        super.update()
        
        switch state {
        case .pressed, .highlighted:
            layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.15).cgColor
        default:
            layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
        }
    }
}
