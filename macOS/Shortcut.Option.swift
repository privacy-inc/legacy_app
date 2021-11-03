import AppKit

extension Shortcut {
    final class Option: Control {
        required init?(coder: NSCoder) { nil }
        init(icon: String, color: NSColor) {
            let image = Image(icon: icon, vibrancy: false)
            image.symbolConfiguration = .init(pointSize: 38, weight: .regular)
                .applying(.init(hierarchicalColor: color))

            super.init(layer: false)
            addSubview(image)
            widthAnchor.constraint(equalToConstant: 50).isActive = true
            heightAnchor.constraint(equalTo: widthAnchor).isActive = true
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed, .highlighted:
                alphaValue = 0.6
            default:
                alphaValue = 1
            }
        }
    }
}
