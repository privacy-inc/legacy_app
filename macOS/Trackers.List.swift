import AppKit
import Combine

extension Trackers {
    final class List: Collection<Cell, Info> {
        private(set) weak var pop: Pop?
        private let select = PassthroughSubject<CGPoint, Never>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(active: .activeInKeyWindow)
            
            let vertical = CGFloat(30)
            let info = PassthroughSubject<[Info], Never>()
            
            cloud
                .first()
                .merge(with: cloud
                        .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main))
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
                .sink { [weak self] in
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
                    $0
                }
                .sink { [weak self] item in
                    guard let self = self else { return }
                    
                    var edge = NSRectEdge.maxY
                    var point = CGRect(x: 80,
                                       y: self.convert(item.rect.origin, from: self.documentView!).y + 64,
                                       width: 1,
                                       height: 1)
                    
                    if !self.bounds.contains(point) {
                        point.origin.y -= 80
                        edge = .minY
                    }
                    
                    self.pop?.close()
                    
                    let pop = Pop(trackers: item.info.trackers)
                    pop.show(relativeTo: point, of: self, preferredEdge: edge)
                    pop.contentViewController?.view.window?.makeKey()
                    self.pop = pop
                }
                .store(in: &subs)
            
            render
                .sink { [weak self] in
                    self?.pop?.close()
                    self?.pop = nil
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
