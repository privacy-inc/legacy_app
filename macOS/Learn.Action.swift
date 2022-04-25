import AppKit

extension Learn {
    final class Action: Control {
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(item: Item) {
            let text = Text(vibrancy: false)
            text.stringValue = item.title
            text.font = .preferredFont(forTextStyle: .body)
            self.text = text
            
            super.init(layer: true)
            addSubview(text)
            
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 12).isActive = true
            
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            text.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            NSApp.effectiveAppearance.performAsCurrentDrawingAppearance {
                text.textColor = .labelColor

                switch state {
                case .highlighted, .pressed, .selected:
                    layer!.backgroundColor = NSColor.separatorColor.cgColor
                default:
                    layer!.backgroundColor = .clear
                }
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
