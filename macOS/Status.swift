import Foundation
import Combine
import Specs

final class Status {
    let current: CurrentValueSubject<UUID, Never>
    let items: CurrentValueSubject<[Item], Never>
    let focus = PassthroughSubject<Void, Never>()
    let websites = PassthroughSubject<[Website], Never>()
    let up = PassthroughSubject<Bool, Never>()
    let complete = PassthroughSubject<String, Never>()
    let widthOn = CurrentValueSubject<_, Never>(CGFloat())
    let widthOff = CurrentValueSubject<_, Never>(CGFloat())

    var item: Item {
        items
            .value
            .first {
                $0.id == current.value
            }!
    }
    
    convenience init() {
        self.init(item: .init(flow: .list))
    }
    
    init(item: Item) {
        items = .init([item])
        current = .init(item.id)
    }
    
    func addTab() {
        let item = Item(flow: .list)
        items.value.append(item)
        current.send(item.id)
    }
    
//    func dismiss() async {
//        guard
//            case let .error(web, _) = item.flow,
//            let url = await web.url,
//            let title = await web.title
//        else {
//            let current = current.value
//            addTab()
//            close(id: current)
//            return
//        }
//
////        await cloud.update(url: url, history: web.history)
////        await cloud.update(title: title, history: web.history)
//        await change(flow: .web(web), index: index)
//    }
    
//    func nextTab() {
//        let index = index
//        if index > 0 {
//            current.value = items.value[index - 1].id
//        } else {
//            current.value = items.value.last!.id
//        }
//    }
    
//    func previousTab() {
//        let index = index
//        if index < items.value.count - 1 {
//            current.value = items.value[index + 1].id
//        } else {
//            current.value = items.value.first!.id
//        }
//    }
    
    func close(id: UUID) {
        guard items.value.count > 1 else { return }
        
        if current.value == id {
            shift(id: id)
        }
        
        items
            .value
            .remove {
                $0.id == id
            }
            .map {
                $0.clear()
            }
    }
    
    func close(except: UUID) {
        current.value = except
        
        items
            .value
            .removeAll {
                guard $0.id == except else {
                    $0.clear()
                    return true
                }
                return false
            }
    }
    
    func moveToNewWindow(id: UUID) {
        if current.value == id {
            shift(id: id)
        }
        
        Window(status: .init(item: items
            .value
            .remove {
                $0.id == id
            }!))
    }
    
    
    
    @MainActor func search(string: String, id: UUID) async {
        do {
            switch item.flow {
            case .list:
                try await open(url: cloud.search(string), id: id)
            case let .web(web):
                try await web.load(url: cloud.search(string))
            case let .error(web, _):
                break
//                try await cloud.search(search, history: web.history)
//                await web.access()
//                change(flow: .web(web))
            }
        } catch {
            
        }
    }
    
//    @MainActor func silent(url: URL) async {
//        let web = await Web(status: self, item: .init(), history: cloud.open(url: url), settings: cloud.model.settings.configuration)
//        items.value.append(.init(id: web.item, web: web))
//        await web.access()
//        current.send(current.value)
//    }
    
    @MainActor func open(url: URL, id: UUID) async {
        let web = await Web(status: self, item: current.value, settings: cloud.model.settings.configuration)
        change(flow: .web(web), id: id)
        web.load(url: url)
    }
    
    @MainActor func change(flow: Flow, id: UUID) {
        let index = index(of: id)
        items.value[index] = items.value[index].with(flow: flow)
    }
    
    private func shift(id: UUID) {
        let index = index(of: id)
        if index > 0 {
            current.value = items.value[index - 1].id
        } else {
            current.value = items.value[index + 1].id
        }
    }
    
    private func index(of: UUID) -> Int {
        items
            .value
            .firstIndex {
                $0.id == of
            }!
    }
}
