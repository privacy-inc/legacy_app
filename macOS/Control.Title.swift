import AppKit

extension Control {
    final class Title: Control {
        required init?(coder: NSCoder) { nil }
        init(_ title: String) {
            let text = Text(vibrancy: false)
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .body)
            text.textColor = .labelColor
            
            super.init(layer: true)
            layer!.cornerRadius = 6
            addSubview(text)
            
            heightAnchor.constraint(equalToConstant: 29).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .off:
                layer!.backgroundColor = .clear
            case .highlighted, .pressed:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.15).cgColor
            default:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
