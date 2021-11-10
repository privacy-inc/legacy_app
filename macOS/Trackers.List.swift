import AppKit
import Combine

extension Trackers {
    final class List: Collection<Cell, Info> {
        private let select = PassthroughSubject<CGPoint, Never>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            
            let vertical = CGFloat(30)
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
                            .init(id: $0.0, report: $0.1)
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
                                                    x: 0,
                                                    y: $0.y,
                                                    width: Trackers.width,
                                                    height: Cell.height)))
                            $0.y += Cell.height + 6
                        }
                    self.items.send(result.items)
                    self.size.send(.init(width: 0, height: result.y + vertical))
                }
                .store(in: &subs)
        }
    }
}
