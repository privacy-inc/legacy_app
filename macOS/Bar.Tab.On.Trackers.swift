import AppKit

extension Bar.Tab.On {
    final class Trackers: Control {
        private weak var shield: Image!
        private weak var infinity: Image!
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(status: Status, item: UUID) {
            let shield = Image(icon: "shield.lefthalf.filled")
            shield.symbolConfiguration = .init(pointSize: 13, weight: .regular)
            self.shield = shield
            
            let infinity = Image(icon: "infinity")
            infinity.symbolConfiguration = .init(pointSize: 13, weight: .regular)
            infinity.isHidden = true
            self.infinity = infinity
            
            let text = Text(vibrancy: true)
            text.maximumNumberOfLines = 1
            text.lineBreakMode = .byTruncatingTail
            text.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
            text.isHidden = true
            self.text = text
            
            super.init(layer: false)
            addSubview(shield)
            addSubview(text)
            addSubview(infinity)
            
            widthAnchor.constraint(equalToConstant: 49).isActive = true
            heightAnchor.constraint(equalToConstant: Bar.height).isActive = true
            
            shield.leftAnchor.constraint(equalTo: leftAnchor, constant: 7).isActive = true
            shield.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            text.centerXAnchor.constraint(equalTo: rightAnchor, constant: -17).isActive = true
            text.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -0.5).isActive = true
            
            infinity.centerXAnchor.constraint(equalTo: text.centerXAnchor).isActive = true
            infinity.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .pressed, .highlighted:
                shield.contentTintColor = .labelColor
                text.textColor = .labelColor
                infinity.contentTintColor = .labelColor
            default:
                shield.contentTintColor = .secondaryLabelColor
                text.textColor = .secondaryLabelColor
                infinity.contentTintColor = .secondaryLabelColor
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
