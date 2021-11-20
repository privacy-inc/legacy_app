import AppKit

extension Ellipsis {
    final class Option: Control {
        required init?(coder: NSCoder) { nil }
        init(title: String, symbol: String) {
            let text = Text(vibrancy: false)
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .body)
            text.textColor = .labelColor
            
            let icon = Image(icon: symbol)
            icon.symbolConfiguration = .init(textStyle: .body)
                .applying(.init(hierarchicalColor: .labelColor))
            
            super.init(layer: true)
            layer!.cornerRadius = 8
            addSubview(text)
            addSubview(icon)
            
            widthAnchor.constraint(equalToConstant: 240).isActive = true
            heightAnchor.constraint(equalToConstant: 36).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
            
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            icon.centerXAnchor.constraint(equalTo: rightAnchor, constant: -26).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .pressed:
                layer!.backgroundColor = NSColor.tertiaryLabelColor.cgColor
            case .highlighted:
                layer!.backgroundColor = NSColor.quaternaryLabelColor.cgColor
            default:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
