import AppKit

extension Control {
    final class Symbol: Control {
        private weak var image: NSImageView!
        private let hierarchical: Bool
        
        required init?(coder: NSCoder) { nil }
        init(_ name: String, point: CGFloat, size: CGFloat, weight: NSFont.Weight, hierarchical: Bool) {
            let image = NSImageView(image: .init(systemSymbolName: name, accessibilityDescription: nil) ?? .init())
            image.translatesAutoresizingMaskIntoConstraints = false
            image.symbolConfiguration = .init(pointSize: point, weight: weight)
            self.image = image
            self.hierarchical = hierarchical
            
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
                if hierarchical {
                    image.symbolConfiguration = image.symbolConfiguration!.applying(.init(hierarchicalColor: .labelColor))
                } else {
                    image.contentTintColor = .labelColor
                }
            default:
                if hierarchical {
                    image.symbolConfiguration = image.symbolConfiguration!.applying(.init(hierarchicalColor: .secondaryLabelColor))
                } else {
                    image.contentTintColor = .secondaryLabelColor
                }
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
