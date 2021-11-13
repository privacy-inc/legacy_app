import AppKit

extension Shortcut {
    final class Action: Control {
        required init?(coder: NSCoder) { nil }
        init(title: String) {
            let text = Text(vibrancy: true)
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .body)
            text.textColor = .labelColor
            
            super.init(layer: true)
            layer!.cornerRadius = 5
            addSubview(text)
            
            heightAnchor.constraint(equalToConstant: 26).isActive = true
            widthAnchor.constraint(equalToConstant: 86).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func update() {
            super.update()
            
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
}
