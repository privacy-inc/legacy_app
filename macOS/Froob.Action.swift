import AppKit

extension Froob {
    final class Action: Control {
        required init?(coder: NSCoder) { nil }
        init(title: String, color: NSColor, foreground: NSColor) {
            let text = Text(vibrancy: false)
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .title3)
            text.textColor = foreground
            
            super.init(layer: true)
            layer!.cornerRadius = 10
            layer!.backgroundColor = color.cgColor
            addSubview(text)
            
            heightAnchor.constraint(equalToConstant: 38).isActive = true
            widthAnchor.constraint(equalToConstant: 320).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
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
