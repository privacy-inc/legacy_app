import AppKit

extension Trackers {
    final class Cell: CollectionCell<Info> {
        static let insetsHorizontal2 = insetsHorizontal * 2
        static let insetsVertical2 = insetsVertical * 2
        private static let insetsHorizontal = CGFloat(20)
        private static let insetsVertical = CGFloat(12)
        private weak var text: CollectionCellText!
        private weak var separator: Shape!
        
        override var item: CollectionItem<Info>? {
            didSet {
                guard
                    item != oldValue,
                    let item = item
                else { return }
                frame = item.rect
                text.frame.size = .init(width: item.rect.width - Self.insetsHorizontal2, height: item.rect.height - Self.insetsVertical2)
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
                x: Self.insetsHorizontal,
                y: Self.insetsVertical,
                width: 0,
                height: 0)
            addSublayer(text)
            self.text = text
            
            let separator = Shape()
            separator.fillColor = .clear
            separator.lineWidth = 1
            separator.strokeColor = NSColor.separatorColor.cgColor
            separator.path = .init(rect: .init(x: Self.insetsHorizontal, y: -1, width: List.cellWidth, height: 0), transform: nil)
            addSublayer(separator)
            self.separator = separator
        }
        
        override func update() {
            switch state {
            case .pressed:
                text.string = item?.info.stringHighlighted
                backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            default:
                text.string = item?.info.string
                backgroundColor = .clear
            }
        }
    }
}
