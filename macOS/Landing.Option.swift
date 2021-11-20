import AppKit

extension Landing {
    final class Option: Control {
        private weak var image: Image!
        
        required init?(coder: NSCoder) { nil }
        init(icon: String) {
            let image = Image(icon: icon)
            image.symbolConfiguration = .init(pointSize: 18, weight: .regular)
            image.contentTintColor = .secondaryLabelColor
            self.image = image
            
            super.init(layer: false)
            addSubview(image)
            widthAnchor.constraint(equalToConstant: 40).isActive = true
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
                image.contentTintColor = .secondaryLabelColor
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
