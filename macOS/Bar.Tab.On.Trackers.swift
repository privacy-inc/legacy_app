import AppKit

extension Bar.Tab.On {
    final class Trackers: Control {
        private weak var image: Image!
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(status: Status, item: UUID) {
            let image = Image(icon: "shield.lefthalf.filled")
            image.symbolConfiguration = .init(pointSize: 12, weight: .regular)
            self.image = image
            
            let text = Text(vibrancy: true)
            text.stringValue = "32342323"
            text.maximumNumberOfLines = 1
            text.lineBreakMode = .byTruncatingTail
            text.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
//            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            self.text = text
            
            super.init(layer: true)
            addSubview(image)
            addSubview(text)
            layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
            
            widthAnchor.constraint(lessThanOrEqualToConstant: 80).isActive = true
            rightAnchor.constraint(equalTo: text.rightAnchor, constant: 5).isActive = true
            heightAnchor.constraint(equalTo: widthAnchor).isActive = true
            
            let width = widthAnchor.constraint(equalToConstant: 80)
            width.priority = .defaultHigh
            width.isActive = true
            
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: image.rightAnchor).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .pressed, .highlighted:
                image.contentTintColor = .labelColor
                text.textColor = .labelColor
            default:
                image.contentTintColor = .tertiaryLabelColor
                text.textColor = .tertiaryLabelColor
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
