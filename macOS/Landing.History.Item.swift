/*import AppKit
import Specs

extension Landing.History {
    class Item: Control {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(layer: true)
            layer!.cornerRadius = 12
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .pressed, .highlighted:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            default:
                layer!.backgroundColor = .clear
            }
        }
    }
}
*/
