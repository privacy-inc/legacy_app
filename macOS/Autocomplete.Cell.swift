import AppKit
import Combine

extension Autocomplete {
    final class Cell: CollectionCell<Info> {
        static let size = CGSize(width: Bar.Tab.On.width - 24, height: 56)
        private weak var text: CollectionCellText!
        private weak var icon: CollectionCellImage!
        private weak var separator: Shape!
        private var sub: AnyCancellable?
        
        override var item: CollectionItem<Info>? {
            didSet {
                guard
                    item != oldValue,
                    let item = item
                else { return }
                
                if item.rect != oldValue?.rect {
                    frame = item.rect
                    
                    let width = item.rect.size.width - 75
                    let height = item.info.text.height(for: width)
                    text.frame = .init(
                        x: 54,
                        y: (Self.size.height - height) / 2,
                        width: width,
                        height: height)
                    separator.isHidden = item.info.first
                }
                
                if item.info != oldValue?.info {
                    text.string = item.info.text
                    sub?.cancel()
                    icon.contents = NSImage(systemSymbolName: "network", accessibilityDescription: nil)?
                        .withSymbolConfiguration(.init(pointSize: 32, weight: .ultraLight)
                                                    .applying(.init(hierarchicalColor: .tertiaryLabelColor)))
                    
                    Task
                        .detached { [weak self] in
                            await self?.update(icon: item.info.access.icon)
                        }
                }
            }
        }
        
        required init?(coder: NSCoder) { nil }
        override init(layer: Any) { super.init(layer: layer) }
        required init() {
            super.init()
            cornerCurve = .continuous
            cornerRadius = 8
            
            let icon = CollectionCellImage()
            icon.cornerRadius = 6
            icon.frame = .init(
                x: 16,
                y: 16,
                width: 24,
                height: 24)
            addSublayer(icon)
            self.icon = icon
            
            let text = CollectionCellText()
            addSublayer(text)
            self.text = text
            
            let separator = Shape()
            separator.fillColor = .clear
            separator.lineWidth = 1
            separator.strokeColor = NSColor.separatorColor.cgColor
            separator.path = .init(rect: .init(x: 20, y: -1, width: Self.size.width - 40, height: 0), transform: nil)
            addSublayer(separator)
            self.separator = separator
        }
        
        override func update() {
            switch state {
            case .highlighted, .pressed:
                backgroundColor = NSColor.labelColor.withAlphaComponent(0.15).cgColor
            default:
                backgroundColor = .clear
            }
        }
        
        private func update(icon: String?) async {
            guard
                let icon = icon,
                let publisher = await favicon.publisher(for: icon)
            else { return }
            sub = publisher
                .sink { [weak self] in
                    self?.icon.contents = $0
                }
        }
    }
}
