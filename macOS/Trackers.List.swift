import AppKit
import Combine

extension Trackers {
    final class List: Collection<Cell, Info> {
        static let cellWidth = width - Cell.insetsHorizontal2
        private static let width = Trackers.width - insets2
        private static let insets = CGFloat(20)
        private static let insets2 = insets + insets
        private let select = PassthroughSubject<CGPoint, Never>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            
            let vertical = CGFloat(20)
            let info = PassthroughSubject<[Info], Never>()
            
            cloud
                .map {
                    $0
                        .events
                        .report
                        .filter {
                            !$0.trackers.isEmpty
                        }
                }
                .map {
                    $0
                        .enumerated()
                        .map {
                            .init(id: $0.0, first: $0.0 == 0, report: $0.1)
                        }
                }
                .subscribe(info)
                .store(in: &subs)
            
            info
                .removeDuplicates()
                .sink {
                    let result = $0
                        .reduce(into: (items: Set<CollectionItem<Info>>(), y: vertical)) {
                            $0.items.insert(.init(
                                                info: $1,
                                                rect: .init(
                                                    x: Self.insets,
                                                    y: $0.y,
                                                    width: Self.width,
                                                    height: Cell.height)))
                            $0.y += Cell.height + 2
                        }
                    self.items.send(result.items)
                    self.size.send(.init(width: 0, height: result.y + vertical))
                }
                .store(in: &subs)
        }
    }
}
