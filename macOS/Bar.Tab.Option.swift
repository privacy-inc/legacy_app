import AppKit

extension Bar.Tab {
    final class Option: Control {
        private weak var image: Image!
        private let color: NSColor
        
        required init?(coder: NSCoder) { nil }
        init(icon: String, size: CGFloat = 16, color: NSColor = .secondaryLabelColor) {
            let image = Image(icon: icon)
            image.symbolConfiguration = .init(pointSize: size, weight: .regular)
            image.contentTintColor = .secondaryLabelColor
            self.image = image
            self.color = color
            
            super.init(layer: false)
            addSubview(image)
            widthAnchor.constraint(equalToConstant: 28).isActive = true
            heightAnchor.constraint(equalTo: widthAnchor).isActive = true
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .pressed, .highlighted:
                image.contentTintColor = .labelColor
            default:
                image.contentTintColor = color
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
