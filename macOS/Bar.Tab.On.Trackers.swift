import AppKit

extension Bar.Tab.On {
    final class Trackers: Control {
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(status: Status, item: UUID) {
            let text = Text(vibrancy: true)
            text.maximumNumberOfLines = 1
            text.lineBreakMode = .byTruncatingTail
            text.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
            text.isHidden = true
            self.text = text
            
            super.init(layer: false)
            addSubview(text)
            
            widthAnchor.constraint(equalToConstant: 49).isActive = true
            heightAnchor.constraint(equalToConstant: Bar.height).isActive = true
            
            text.centerXAnchor.constraint(equalTo: rightAnchor, constant: -17).isActive = true
            text.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -0.5).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .pressed, .highlighted:
                text.textColor = .labelColor
            default:
                text.textColor = .secondaryLabelColor
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
