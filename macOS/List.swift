import AppKit
import Combine
import Specs

final class List: Collection<ListCell, ListInfo> {
     private let select = PassthroughSubject<CGPoint, Never>()
 
     required init?(coder: NSCoder) { nil }
     init(status: Status) {
         super.init(active: .activeAlways)
         scrollerInsets.top = 8
         scrollerInsets.bottom = 8
         
         let vertical = CGFloat(15)
         let info = CurrentValueSubject<[ListInfo], Never>([])
         let selected = PassthroughSubject<ListInfo.ID, Never>()
         
         status
             .websites
             .sink { [weak self] _ in
                 self?.contentView.bounds.origin.y = 0
             }
             .store(in: &subs)

         status
             .websites
             .removeDuplicates {
                 $0.map(\.id) == $1.map(\.id)
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
                 guard !$0.isEmpty else {
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
                                                 width: status.widthOn.value - 24,
                                                 height: 56)))
                         $0.y += 58
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
             .sink { [weak self] website in
                 self?.window?.close()
                 
//                 Task {
//                     await status.reaccess(access: access)
//                 }
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
         contentView.bounds.origin.y = y - bounds.midY
         contentView.layer?.add({
             $0.duration = 0.2
             $0.timingFunction = .init(name: .easeInEaseOut)
             return $0
         } (CABasicAnimation(keyPath: "bounds")), forKey: "bounds")
     }
 }
