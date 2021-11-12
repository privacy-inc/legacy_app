import AppKit
import Combine

extension Websites {
    final class List: Collection<Cell, Info> {
        let info = PassthroughSubject<[Info], Never>()
        private let select = PassthroughSubject<CGPoint, Never>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            
            let vertical = CGFloat(30)
            
            
            
            
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
            
            select
                .map { point in
                    self
                        .cells
                        .compactMap(\.item)
                        .first {
                            $0
                                .rect
                                .contains(point)
                        }
                }
                .compactMap {
                    $0
                }
                .sink { [weak self] item in
                    
                }
                .store(in: &subs)
        }
        
        override func mouseUp(with: NSEvent) {
            switch with.clickCount {
            case 1:
                select.send(point(with: with))
            default:
                break
            }
        }
    }
}
