import AppKit
import Combine
import Specs

final class List: Collection<ListCell, ListInfo>, NSMenuDelegate {
    private weak var status: Status!
    private let select = PassthroughSubject<CGPoint, Never>()
    
    required init?(coder: NSCoder) { nil }
    init(status: Status, width: CGFloat?) {
        self.status = status
        
        super.init(active: .activeAlways)
        alphaValue = 0
        scrollerInsets.top = 8
        scrollerInsets.bottom = 8
        menu = .init()
        menu!.delegate = self
        
        let vertical = CGFloat(15)
        let info = CurrentValueSubject<[ListInfo], Never>([])
        let selected = PassthroughSubject<ListInfo.ID, Never>()
        
        status
            .filter
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.contentView.bounds.origin.y = 0
            }
            .store(in: &subs)
        
        cloud
            .combineLatest(status
                .filter
                .removeDuplicates()) {
                    $0.websites(filter: $1)
                }
                .map {
                    $0
                        .enumerated()
                        .map { item in
                                .init(website: item.1, first: item.0 == 0)
                        }
                }
                .subscribe(info)
                .store(in: &subs)
        
        info
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] in
                guard
                    !$0.isEmpty,
                    let width = width ?? self.map(\.frame.width).map({ $0 - 24 })
                else {
                    self?.items.send([])
                    self?.size.send(.init(width: 0, height: 0))
                    return
                }
                
                let result = $0
                    .reduce(into: (items: Set<CollectionItem<ListInfo>>(), y: vertical)) {
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
        
        status
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
                    status.complete.send(info[index].id)
                }
            }
            .store(in: &subs)
        
        selected
            .compactMap { id in
                info.value.first { $0.id == id }?.website
            }
            .sink { website in
                //                 self?.window?.close()
                
                Task {
                    await status.open(url: URL(string: website.id)!, id: status.current.value)
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
    
    final func menuNeedsUpdate(_ menu: NSMenu) {
        menu.items = highlighted.value == nil
            ? []
            : [
                .child("Open", #selector(open)) {
                    $0.target = self
                    $0.image = .init(systemSymbolName: "arrow.up", accessibilityDescription: nil)
                },
                .separator(),
                .child("Delete", #selector(delete)) {
                    $0.target = self
                    $0.image = .init(systemSymbolName: "trash", accessibilityDescription: nil)
                }]
    }
    
    @objc private func open() {
        _ = highlighted
            .value
            .map { url in
                Task {
                    await status.open(url: URL(string: url)!, id: status.current.value)
                }
            }
    }
    
    @objc private func delete() {
        _ = highlighted
            .value
            .map { url in
                Task {
                    await cloud.delete(url: url)
                }
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
