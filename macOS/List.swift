import AppKit
import Combine
import Specs

final class List: Collection<ListCell, ListInfo> {
    let top = CurrentValueSubject<_, Never>(CGFloat(15))
    let empty = CurrentValueSubject<_, Never>(true)
    let selected = PassthroughSubject<ListInfo.ID, Never>()
    private let session: Session
    private let select = PassthroughSubject<CGPoint, Never>()
    
    required init?(coder: NSCoder) { nil }
    init(session: Session, width: CGFloat) {
        self.session = session
        
        super.init(active: .activeAlways)
        alphaValue = 0
        scrollerInsets.top = 8
        scrollerInsets.bottom = 8
        
        let bottom = CGFloat(15)
        let info = CurrentValueSubject<[ListInfo], Never>([])
        
        session
            .filter
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.contentView.bounds.origin.y = 0
            }
            .store(in: &subs)
        
        cloud
            .combineLatest(session
                .filter
                .removeDuplicates()) {
                    $0.websites(filter: $1)
                }
                .removeDuplicates()
                .map {
                    $0
                        .enumerated()
                        .map { item in
                                .init(website: item.1, first: item.0 == 0)
                        }
                }
                .sink { [weak self] (items: [ListInfo]) -> Void in
                    info.send(items)
                    self?.empty.send(items.isEmpty)
                }
                .store(in: &subs)
        
        info
            .dropFirst()
            .removeDuplicates()
            .combineLatest(top
                .removeDuplicates())
            .sink { [weak self] info, top in
                guard !info.isEmpty else {
                    self?.items.send([])
                    self?.size.send(.init(width: 0, height: 0))
                    return
                }
                
                let result = info
                    .reduce(into: (items: Set<CollectionItem<ListInfo>>(), y: top)) {
                        $0.items.insert(.init(
                            info: $1,
                            rect: .init(
                                x: 12,
                                y: $0.y,
                                width: width,
                                height: 50)))
                        $0.y += 52
                    }
                self?.items.send(result.items)
                self?.size.send(.init(width: 0, height: result.y + bottom))
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
            .sink { [weak self] in
                self?.selected.send($0)
            }
            .store(in: &subs)
        
        session
            .up
            .map { up -> (up: Bool, date: Date) in
                (up: up, date: Date())
            }
            .combineLatest(info,
                           highlighted,
                           items)
            .removeDuplicates { (first: (move: (up: Bool, date: Date), _, _, _),
                                 second: (move: (up: Bool, date: Date), _, _, _)) -> Bool in
                
                first.move.date == second.move.date
            }
            .sink { [weak self] move, info, highlighted, items in
                (info
                    .firstIndex {
                        $0.id == highlighted
                    }
                 ?? (info.isEmpty
                     ? nil
                     : move.up ? 0 : info.count - 1))
                .map { (index: Int) in
                    move.up ? index > 0
                    ? index - 1
                    : info.count - 1
                    : index < info.count - 1
                    ? index + 1
                    : 0
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
                    session.complete.send(info[index].id)
                }
            }
            .store(in: &subs)
        
        selected
            .compactMap { id in
                info.value.first { $0.id == id }?.website
            }
            .sink { website in
                Task {
                    await session.open(url: URL(string: website.id)!, id: session.current.value)
                }
            }
            .store(in: &subs)
        
        NSAnimationContext
            .runAnimationGroup {
                $0.duration = 0.4
                $0.allowsImplicitAnimation = true
                $0.timingFunction = .init(name: .easeInEaseOut)
                animator().alphaValue = 1
            }
    }
    
    override func mouseUp(with: NSEvent) {
        switch with.clickCount {
        case 1:
            select.send(point(with: with))
        default:
            break
        }
    }
    
    private func center(y: CGFloat) {
        contentView.bounds.origin.y = y - bounds.midY
        contentView.layer?.add({
            $0.duration = 0.2
            $0.timingFunction = .init(name: .easeInEaseOut)
            return $0
        } (CABasicAnimation(keyPath: "bounds")), forKey: "bounds")
    }
}
