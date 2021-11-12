import AppKit
import Combine

extension Websites {
    final class List: Collection<Cell, Info>, NSMenuDelegate {
        let info = PassthroughSubject<[Info], Never>()
        let open = PassthroughSubject<Int, Never>()
        let delete = PassthroughSubject<Int, Never>()
        private static let insets = CGFloat(30)
        private static let insets2 = insets + insets
        private let select = PassthroughSubject<CGPoint, Never>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            menu = .init()
            menu!.delegate = self
            
            let vertical = CGFloat(30)
            let width = PassthroughSubject<CGFloat, Never>()
            
            NotificationCenter
                .default
                .publisher(for: NSView.frameDidChangeNotification, object: contentView)
                .compactMap {
                    ($0.object as? NSView)?.bounds.width
                }
                .map {
                    $0 - Self.insets2
                }
                .removeDuplicates()
                .subscribe(width)
                .store(in: &subs)
            
            info
                .removeDuplicates()
                .combineLatest(width)
                .sink { [weak self] info, width in
                    let result = info
                        .reduce(into: (items: Set<CollectionItem<Info>>(), y: vertical)) {
                            $0.items.insert(.init(
                                                info: $1,
                                                rect: .init(
                                                    x: Self.insets,
                                                    y: $0.y,
                                                    width: width,
                                                    height: Cell.height)))
                            $0.y += Cell.height + 1
                        }
                    self?.items.send(result.items)
                    self?.size.send(.init(width: 0, height: result.y + vertical))
                }
                .store(in: &subs)
            
            select
                .map { [weak self] point in
                    self?
                        .cells
                        .compactMap(\.item)
                        .first {
                            $0
                                .rect
                                .contains(point)
                        }
                }
                .compactMap {
                    $0?.info.id
                }
                .sink { [weak self] in
                    self?.open.send($0)
                }
                .store(in: &subs)
        }
        
        final override func mouseUp(with: NSEvent) {
            switch with.clickCount {
            case 1:
                select.send(point(with: with))
            default:
                break
            }
        }
        
        final func menuNeedsUpdate(_ menu: NSMenu) {
            menu.items = highlighted.value == nil
                ? []
                : [
                    .child("Open", #selector(_open)) {
                        $0.target = self
                        $0.image = .init(systemSymbolName: "arrow.up", accessibilityDescription: nil)
                    },
                    .separator(),
                    .child("Delete", #selector(_delete)) {
                        $0.target = self
                        $0.image = .init(systemSymbolName: "trash", accessibilityDescription: nil)
                    }]
        }
        
        @objc private func _open() {
            highlighted
                .value
                .map(open.send)
        }
        
        @objc private func _delete() {
            highlighted
                .value
                .map(delete.send)
        }
    }
}
