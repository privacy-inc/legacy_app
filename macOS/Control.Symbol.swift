import AppKit

extension Control {
    final class Symbol: Control {
        private weak var image: NSImageView!
        
        required init?(coder: NSCoder) { nil }
        init(_ name: String, point: CGFloat, size: CGFloat) {
            let image = NSImageView(image: .init(systemSymbolName: name, accessibilityDescription: nil) ?? .init())
            image.translatesAutoresizingMaskIntoConstraints = false
            image.symbolConfiguration = .init(pointSize: point, weight: .regular)
            self.image = image
            
            super.init(layer: false)
            addSubview(image)
            widthAnchor.constraint(equalToConstant: size).isActive = true
            heightAnchor.constraint(equalToConstant: size).isActive = true
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .pressed, .highlighted:
                image.contentTintColor = .labelColor
            default:
                image.contentTintColor = .secondaryLabelColor
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
