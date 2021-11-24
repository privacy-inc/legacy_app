import AppKit

extension Forgetting {
    final class Option: Control {
        required init?(coder: NSCoder) { nil }
        init(title: String, image: String) {
            let image = Image(icon: image)
            image.symbolConfiguration = .init(textStyle: .title3, scale: .large)
                .applying(.init(hierarchicalColor: .secondaryLabelColor))
            
            let text = Text(vibrancy: true)
            text.stringValue = title
            text.textColor = .secondaryLabelColor
            text.font = .preferredFont(forTextStyle: .body)
            
            super.init(layer: true)
            layer!.cornerRadius = 6
            
            addSubview(image)
            addSubview(text)
            
            widthAnchor.constraint(equalToConstant: 160).isActive = true
            heightAnchor.constraint(equalToConstant: 36).isActive = true
            
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.centerXAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .pressed, .highlighted:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
            default:
                layer!.backgroundColor = .clear
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
