import AppKit

extension Autocomplete {
    final class Cell: CollectionCell<Info> {
        static let size = CGSize(width: Bar.Tab.On.width - 24, height: 56)
        private weak var text: Text!
        private weak var icon: Icon!
        private weak var separator: Shape!
        private weak var vibrant: Vibrant!
        
        override var item: CollectionItem<Info>? {
            didSet {
                guard
                    item != oldValue,
                    let item = item
                else { return }
                
                separator.isHidden = item.info.first
                
                if item.rect != oldValue?.rect {
                    frame = item.rect
                    vibrant.frame = bounds
                    
                    let width = item.rect.size.width - 70
                    let height = item.info.text.height(for: width)
                    text.frame = .init(
                        x: 54,
                        y: (Self.size.height - height) / 2,
                        width: width,
                        height: height)
                }
                
                if item.info != oldValue?.info {
                    text.attributedStringValue = item.info.text
                    icon.icon(icon: item.info.access.icon)
                }
            }
        }
        
        required init?(coder: NSCoder) { nil }
        required init() {
            let vibrant = Vibrant(layer: true)
            vibrant.layer!.cornerCurve = .continuous
            vibrant.layer!.cornerRadius = 8
            self.vibrant = vibrant
            
            let separator = Shape()
            separator.fillColor = .clear
            separator.lineWidth = 1
            separator.path = .init(rect: .init(x: 20, y: 57, width: Self.size.width - 40, height: 0), transform: nil)
            self.separator = separator
            
            super.init()
            addSubview(vibrant)
            layer!.masksToBounds = false
            layer!.addSublayer(separator)
            
            let icon = Icon(size: 24)
            icon.translatesAutoresizingMaskIntoConstraints = true
            icon.frame = .init(
                x: 16,
                y: 16,
                width: 24,
                height: 24)
            addSubview(icon)
            self.icon = icon
            
            let text = Text(vibrancy: true)
            text.translatesAutoresizingMaskIntoConstraints = true
            addSubview(text)
            self.text = text
        }
        
        override func updateLayer() {
            switch state {
            case .highlighted, .pressed:
                vibrant.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
            default:
                vibrant.layer!.backgroundColor = .clear
            }
            
            separator.strokeColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
        }
    }
}
