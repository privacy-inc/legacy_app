/*import AppKit

extension Trackers {
    final class Cell: CollectionCell<Info> {
        static let height = CGFloat(80)
        private weak var text: Text!
        private weak var count: Text!
        private weak var icon: Icon!
        private weak var container: Layer!

        override var item: CollectionItem<Info>? {
            didSet {
                guard
                    item != oldValue,
                    let item = item
                else { return }
                frame = item.rect
                
                if item.info != oldValue?.info {
                    let height = item.info.text.height(for: 300) + 2
                    let width = item.info.count.width(for: 18) + 2
                    
                    text.frame = .init(
                        x: 116,
                        y: (Self.height - height) / 2,
                        width: 300,
                        height: height)
                    
                    count.frame = .init(
                        x: Trackers.width - (width + 70),
                        y: (Self.height - 18) / 2,
                        width: width,
                        height: 18)
                    
                    text.attributedStringValue = item.info.text
                    count.attributedStringValue = item.info.count
                    icon.icon(icon: item.info.icon)
                }
            }
        }
        
        required init?(coder: NSCoder) { nil }
        required init() {
            let container = Layer()
            container.frame = .init(
                x: 40,
                y: 0,
                width: Trackers.width - 80,
                height: Self.height)
            container.cornerRadius = 12
            self.container = container
            
            super.init()
            layer!.addSublayer(container)
            
            let line = Shape()
            line.fillColor = .clear
            line.lineWidth = 1
            line.strokeColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
            line.path = .init(rect: .init(x: 1, y: 39.5, width: 54, height: 0), transform: nil)
            layer!.addSublayer(line)
            
            let background = Layer()
            background.frame = .init(
                x: 56,
                y: 16,
                width: 48,
                height: 48)
            background.cornerRadius = 8
            background.cornerCurve = .continuous
            background.borderColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
            background.borderWidth = 1
            layer!.addSublayer(background)
            
            let icon = Icon()
            icon.translatesAutoresizingMaskIntoConstraints = true
            icon.frame = .init(
                x: 64,
                y: 24,
                width: 32,
                height: 32)
            addSubview(icon)
            self.icon = icon
            
            let text = Text(vibrancy: true)
            text.translatesAutoresizingMaskIntoConstraints = true
            addSubview(text)
            self.text = text
            
            let count = Text(vibrancy: true)
            addSubview(count)
            self.count = count
        }
        
        override func updateLayer() {
            switch state {
            case .highlighted, .pressed:
                container.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            default:
                container.backgroundColor = .clear
            }
        }
    }
}
*/
