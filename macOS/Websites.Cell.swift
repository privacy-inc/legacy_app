import AppKit

extension Websites {
    final class Cell: CollectionCell<Info> {
        static let height = CGFloat(66)
        private weak var text: Text!
        private weak var icon: Icon!
        private weak var separator: Shape!
        
        override var item: CollectionItem<Info>? {
            didSet {
                guard
                    item != oldValue,
                    let item = item
                else { return }
                
                separator.isHidden = item.info.id == 0
                
                if item.rect != oldValue?.rect {
                    frame = item.rect
                    separator.path = .init(rect: .init(x: 17, y: 66.5, width: item.rect.size.width - 34, height: 0), transform: nil)
                    
                    let width = item.rect.size.width - 94
                    let height = item.info.text.height(for: width)
                    text.frame = .init(
                        x: 64,
                        y: (Self.height - height) / 2,
                        width: width,
                        height: height)
                }
                
                if item.info != oldValue?.info {
                    text.attributedStringValue = item.info.text
                    icon.icon(icon: item.info.icon)
                }
            }
        }
        
        required init?(coder: NSCoder) { nil }
        required init() {
            let separator = Shape()
            separator.fillColor = .clear
            separator.lineWidth = 1
            self.separator = separator
            
            super.init()
            layer!.cornerRadius = 12
            layer!.masksToBounds = false
            
            let icon = Icon()
            icon.translatesAutoresizingMaskIntoConstraints = true
            icon.frame = .init(
                x: 17,
                y: 17,
                width: 32,
                height: 32)
            addSubview(icon)
            self.icon = icon
            
            let text = Text(vibrancy: true)
            text.translatesAutoresizingMaskIntoConstraints = true
            addSubview(text)
            self.text = text
            
            layer!.addSublayer(separator)
        }
        
        override func updateLayer() {
            switch state {
            case .highlighted, .pressed:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            default:
                layer!.backgroundColor = .clear
            }
            
            separator.strokeColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
        }
    }
}
