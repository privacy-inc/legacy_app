import AppKit

extension Control {
    final class Title: Control {
        private let layered: Bool
        
        required init?(coder: NSCoder) { nil }
        init(_ title: String, color: NSColor, layer: Bool) {
            self.layered = layer
            
            let text = Text(vibrancy: false)
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .body)
            text.textColor = color
            
            super.init(layer: layer)
            if layered {
                self.layer?.cornerRadius = 6
            }
            addSubview(text)
            
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 6).isActive = true
            rightAnchor.constraint(equalTo: text.rightAnchor, constant: 12).isActive = true
            
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
            text.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            if layered {
                switch state {
                case .off:
                    layer!.backgroundColor = .clear
                case .highlighted, .pressed:
                    layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.15).cgColor
                default:
                    layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
                }
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
