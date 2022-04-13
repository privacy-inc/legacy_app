import AppKit

extension Control {
    final class Capsule: Control {
        required init?(coder: NSCoder) { nil }
        init(_ title: String, color: NSColor, foreground: NSColor) {
            let text = Text(vibrancy: false)
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .body)
            text.textColor = foreground
            
            super.init(layer: true)
            layer!.cornerRadius = 15
            layer!.backgroundColor = color.cgColor
            addSubview(text)
            
            heightAnchor.constraint(equalToConstant: 30).isActive = true
            rightAnchor.constraint(equalTo: text.rightAnchor, constant: 17).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 17).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
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
