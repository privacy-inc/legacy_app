import AppKit

extension Autocomplete {
    final class Cell: CollectionCell<Info> {
        private weak var text: CollectionCellText!
        private weak var separator: Shape!
        
        override var item: CollectionItem<Info>? {
            didSet {
                guard
                    item != oldValue,
                    let item = item
                else { return }
                frame = item.rect
                text.frame.size = item.rect.size
                text.string = item.info.string
                separator.isHidden = item.info.first
            }
        }
        
        required init?(coder: NSCoder) { nil }
        override init(layer: Any) { super.init(layer: layer) }
        required init() {
            super.init()
            cornerRadius = 6
            
            let text = CollectionCellText()
            text.frame = .init(
                x: 0,
                y: 0,
                width: 0,
                height: 0)
            addSublayer(text)
            self.text = text
            
            let separator = Shape()
            separator.fillColor = .clear
            separator.lineWidth = 1
            separator.strokeColor = NSColor.separatorColor.cgColor
            separator.path = .init(rect: .init(x: 0, y: -1, width: 100, height: 0), transform: nil)
            addSublayer(separator)
            self.separator = separator
        }
        
        override func update() {
            switch state {
            case .pressed:
                backgroundColor = NSColor.quaternaryLabelColor.cgColor
            case .highlighted:
                backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            default:
                backgroundColor = .clear
            }
        }
    }
}
