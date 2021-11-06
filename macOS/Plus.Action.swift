import AppKit

extension Plus {
    final class Action: Control {
        required init?(coder: NSCoder) { nil }
        init(title: String, color: NSColor, foreground: NSColor) {
            let text = Text(vibrancy: false)
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .body)
            text.textColor = foreground
            
            super.init(layer: true)
            layer!.cornerRadius = 16
            layer!.backgroundColor = color.cgColor
            addSubview(text)
            
            heightAnchor.constraint(equalToConstant: 32).isActive = true
            widthAnchor.constraint(equalToConstant: 120).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .off:
                alphaValue = 0.3
            case .pressed:
                alphaValue = 0.8
            default:
                alphaValue = 1
            }
        }
    }
}
