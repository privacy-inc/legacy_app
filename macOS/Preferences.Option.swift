import AppKit

extension Preferences {
    final class Option: Control {
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(title: String) {
            let text = Text(vibrancy: false)
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .body)
            text.textColor = .secondaryLabelColor
            self.text = text
            
            super.init(layer: true)
            layer!.cornerRadius = 6
            addSubview(text)
            
            heightAnchor.constraint(equalToConstant: 32).isActive = true
            rightAnchor.constraint(equalTo: text.rightAnchor, constant: 30).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        }
        
        override func update() {
            super.update()
            
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
