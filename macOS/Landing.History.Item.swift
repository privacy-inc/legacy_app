import AppKit
import Specs

extension Landing.History {
    class Item: Control {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(layer: true)
            layer!.cornerCurve = .continuous
            layer!.cornerRadius = 10
        }
        
        final override func update() {
            super.update()
            
            switch state {
            case .pressed, .highlighted:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            default:
                layer!.backgroundColor = .clear
            }
        }
    }
}
