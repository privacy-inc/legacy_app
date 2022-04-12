import AppKit

extension Control {
    final class Label: Control {
        required init?(coder: NSCoder) { nil }
        init(title: String, symbol: String) {
            let text = Text(vibrancy: false)
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .callout)
            text.textColor = .labelColor
            
            let icon = NSImageView(image: .init(systemSymbolName: symbol, accessibilityDescription: nil) ?? .init())
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.symbolConfiguration = .init(pointSize: 13, weight: .regular)
                .applying(.init(hierarchicalColor: .secondaryLabelColor))
            
            super.init(layer: true)
            layer!.cornerRadius = 8
            addSubview(text)
            addSubview(icon)
            
            heightAnchor.constraint(equalToConstant: 32).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
            
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            icon.centerXAnchor.constraint(equalTo: rightAnchor, constant: -18).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .selected:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.2).cgColor
            case .pressed:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.15).cgColor
            case .highlighted:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
            default:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.035).cgColor
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
