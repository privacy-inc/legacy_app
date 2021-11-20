import AppKit

extension Shortcut {
    final class Option: Control {
        private weak var image: Image!
        
        required init?(coder: NSCoder) { nil }
        init() {
            let image = Image()
            self.image = image

            super.init(layer: false)
            addSubview(image)
            widthAnchor.constraint(equalToConstant: 50).isActive = true
            heightAnchor.constraint(equalTo: widthAnchor).isActive = true
            
            image.topAnchor.constraint(equalTo: topAnchor).isActive = true
            image.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            image.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            image.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .pressed, .highlighted:
                image.image = .init(systemSymbolName: "flame.circle.fill", accessibilityDescription: nil)
                image.symbolConfiguration = .init(pointSize: 38, weight: .regular)
                    .applying(.init(hierarchicalColor: .labelColor))
            default:
                image.image = .init(systemSymbolName: "flame.fill", accessibilityDescription: nil)
                image.symbolConfiguration = .init(pointSize: 22, weight: .regular)
                    .applying(.init(hierarchicalColor: .secondaryLabelColor))
            }
        }

        override var allowsVibrancy: Bool {
            true
        }
    }
}
