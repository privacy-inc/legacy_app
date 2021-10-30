import AppKit

extension Bar.Tab {
    final class Off: Control {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init()
            layer = Privacy.Layer()
            wantsLayer = true
            layer!.cornerRadius = 8
            layer!.cornerCurve = .continuous
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
}
