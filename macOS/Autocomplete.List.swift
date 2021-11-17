import AppKit
import Combine
import Specs

extension Autocomplete {
    final class List: Collection<Cell, Info> {
        let found = PassthroughSubject<[Complete], Never>()
        let move = PassthroughSubject<(date: Date, direction: Move), Never>()
        let complete = PassthroughSubject<String, Never>()
        private let select = PassthroughSubject<CGPoint, Never>()
    
        required init?(coder: NSCoder) { nil }
        init(status: Status) {
            super.init(active: .activeAlways)
            scrollerInsets.top = 8
            scrollerInsets.bottom = 8
            
            let vertical = CGFloat(15)
            let info = CurrentValueSubject<[Info], Never>([])
            let selected = PassthroughSubject<Info.ID, Never>()
            
            found
                .sink { [weak self] _ in
                    self?.contentView.bounds.origin.y = 0
                }
                .store(in: &subs)

            found
                .removeDuplicates {
                    $0.map(\.id) == $1.map(\.id)
                }
                .map {
                    $0
                        .enumerated()
                        .map { item in
                            .init(complete: item.1, first: item.0 == 0)
                        }
                }
                .subscribe(info)
                .store(in: &subs)
            
            info
                .dropFirst()
                .removeDuplicates()
                .sink { [weak self] in
                    guard !$0.isEmpty else {
                        self?.items.send([])
                        self?.size.send(.init(width: 0, height: 0))
                        return
                    }
                    
                    let result = $0
                        .reduce(into: (items: Set<CollectionItem<Info>>(), y: vertical)) {
                            $0.items.insert(.init(
                                                info: $1,
                                                rect: .init(
                                                    x: 12,
                                                    y: $0.y,
                                                    width: Cell.size.width,
                                                    height: Cell.size.height)))
                            $0.y += Cell.size.height + 2
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
                            $0.rect.contains(point)
                        }
                }
                .compactMap {
                    $0?.info.id
                }
                .subscribe(selected)
                .store(in: &subs)
            
            move
                .combineLatest(info,
                               highlighted,
                               items)
                .removeDuplicates {
                    $0.0.0 == $1.0.0
                }
                .sink { [weak self] move, info, highlighted, items in
                    (info
                        .firstIndex {
                            $0.id == highlighted
                        }
                        ?? (info.isEmpty
                            ? nil
                            : move.1 == .down
                                ? info.count - 1
                                : 0))
                        .map { (index: Int) in
                            move.1 == .down
                                ? index < info.count - 1
                                    ? index + 1
                                    : 0
                                : index > 0
                                    ? index - 1
                                    : info.count - 1
                        }
                        .map { index in
                            items
                                .first {
                                    $0.info.id == info[index].id
                                }
                                .map {
                                    self?
                                        .center(y: $0.rect.minY)
                                }
                            self?.highlighted.send(info[index].id)
                            self?.complete.send(info[index].access.value)
                        }
                }
                .store(in: &subs)
            
            selected
                .compactMap { id in
                    info.value.first { $0.id == id }?.access
                }
                .sink { [weak self] access in
                    self?.window?.close()
                    
                    Task {
                        await status.reaccess(access: access)
                    }
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
        
        func center(y: CGFloat) {
            NSAnimationContext
                .runAnimationGroup {
                    $0.duration = 0.3
                    $0.allowsImplicitAnimation = true
                    contentView.bounds.origin.y = y - bounds.midY
                }
        }
    }
}
