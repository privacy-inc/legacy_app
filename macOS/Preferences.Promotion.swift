import AppKit

extension Preferences {
    final class Promotion: Control {
        required init?(coder: NSCoder) { nil }
        init() {
            let text = Text(vibrancy: false)
            text.stringValue = "Privacy"
            text.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .medium)
            text.textColor = .systemBlue
            
            let icon = Image(icon: "plus")
            icon.symbolConfiguration = .init(pointSize: 18, weight: .regular)
            icon.contentTintColor = .systemBlue
            
            super.init(layer: true)
            layer!.cornerRadius = 6
            addSubview(text)
            addSubview(icon)
            
            heightAnchor.constraint(equalToConstant: 26).isActive = true
            rightAnchor.constraint(equalTo: icon.rightAnchor, constant: 12).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
            
            icon.leftAnchor.constraint(equalTo: text.rightAnchor, constant: 6).isActive = true
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .pressed, .highlighted:
                layer!.backgroundColor = NSColor.systemBlue.withAlphaComponent(0.2).cgColor
            default:
                layer!.backgroundColor = .clear
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
