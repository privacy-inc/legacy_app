import AppKit
import Combine

extension Trackers {
    final class Cell: CollectionCell<Info> {
        static let height = CGFloat(80)
        private weak var text: CollectionCellText!
        private weak var count: CollectionCellText!
        private weak var icon: CollectionCellImage!
        private weak var container: Layer!
        private weak var background: Layer!
        private var sub: AnyCancellable?

        override var item: CollectionItem<Info>? {
            didSet {
                guard
                    item != oldValue,
                    let item = item
                else { return }
                frame = item.rect
                text.string = item.info.text
                count.string = item.info.count
                
                if item.info != oldValue?.info {
                    sub?.cancel()
                    icon.contents = NSImage(systemSymbolName: "network", accessibilityDescription: nil)?
                        .withSymbolConfiguration(.init(pointSize: 32, weight: .ultraLight)
                                                    .applying(.init(hierarchicalColor: .tertiaryLabelColor)))

                    Task
                        .detached { [weak self] in
                            await self?.update(icon: item.info.icon)
                        }
                }
            }
        }
        
        required init?(coder: NSCoder) { nil }
        override init(layer: Any) { super.init(layer: layer) }
        required init() {
            super.init()
            
            let line = Shape()
            line.fillColor = .clear
            line.lineWidth = 1
            line.strokeColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
            line.path = .init(rect: .init(x: 1, y: 39.5, width: 54, height: 0), transform: nil)
            addSublayer(line)
            
            let container = Layer()
            container.frame = .init(
                x: 40,
                y: 0,
                width: Trackers.width - 80,
                height: Self.height)
            container.cornerRadius = 12
            addSublayer(container)
            self.container = container
            
            let background = Layer()
            background.frame = .init(
                x: 56,
                y: 16,
                width: 48,
                height: 48)
            background.cornerRadius = 8
            background.cornerCurve = .continuous
            background.borderColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
            addSublayer(background)
            self.background = background
            
            let icon = CollectionCellImage()
            icon.frame = .init(
                x: 64,
                y: 24,
                width: 32,
                height: 32)
            icon.cornerRadius = 6
            icon.cornerCurve = .continuous
            addSublayer(icon)
            self.icon = icon
            
            let text = CollectionCellText()
            text.frame = .init(
                x: 116,
                y: 24,
                width: 300,
                height: 60)
            addSublayer(text)
            self.text = text
            
            let count = CollectionCellText()
            count.alignmentMode = .right
            count.frame = .init(
                x: Trackers.width - 214,
                y: 32,
                width: 150,
                height: 35)
            addSublayer(count)
            self.count = count
        }
        
        override func update() {
            switch state {
            case .highlighted, .pressed:
                container.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
                background.backgroundColor = .clear
                background.borderWidth = 1
            default:
                container.backgroundColor = .clear
                background.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
                background.borderWidth = 0
            }
        }
        
        private func update(icon: String) async {
            guard let publisher = await favicon.publisher(for: icon) else { return }
            sub = publisher
                .sink { [weak self] in
                    self?.icon.contents = $0
                }
        }
    }
}
