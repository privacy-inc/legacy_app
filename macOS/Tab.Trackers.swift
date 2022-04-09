import AppKit

extension Tab {
    final class Trackers: Control {
        private(set) weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(status: Status, item: UUID) {
            let text = Text(vibrancy: true)
            text.maximumNumberOfLines = 1
            text.lineBreakMode = .byTruncatingTail
            text.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
            self.text = text
            
            super.init(layer: true)
            toolTip = "Trackers"
            layer!.cornerRadius = 8
            addSubview(text)
            
            widthAnchor.constraint(equalToConstant: 41).isActive = true
            heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            text.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
            text.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -0.5).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
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
