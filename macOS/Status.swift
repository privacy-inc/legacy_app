import AppKit
import Combine
import Specs

struct Status {
    let current: CurrentValueSubject<UUID, Never>
    let items: CurrentValueSubject<[Item], Never>
    let focus = PassthroughSubject<Void, Never>()
    let filter = PassthroughSubject<String, Never>()
    let up = PassthroughSubject<Bool, Never>()
    let complete = PassthroughSubject<String, Never>()
    let width = CurrentValueSubject<_, Never>((on: CGFloat(), off: CGFloat()))

    init() {
        self.init(item: .init(flow: .list))
    }
    
    init(item: Item) {
        items = .init([item])
        current = .init(item.id)
    }
    
    func addTab() {
        let item = Item(flow: .list)
        current.send(item.id)
        items.value.append(item)
    }
    
    func previous(id: UUID) {
        let index = index(of: id)
        if index > 0 {
            current.value = items.value[index - 1].id
        } else {
            current.value = items.value.last!.id
        }
    }
    
    func next(id: UUID) {
        let index = index(of: id)
        if index < items.value.count - 1 {
            current.value = items.value[index + 1].id
        } else {
            current.value = items.value.first!.id
        }
    }
    
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
    }
    
    func close(except: UUID) {
        current.value = except
        
        items
            .value
            .removeAll {
                $0.id != except
            }
    }
    
    func toNewWindow(id: UUID) {
        if current.value == id {
            shift(id: id)
        }
        NSApp.window(status: .init(item: items
            .value
            .remove {
                $0.id == id
            }!))
    }
    
    func flow(of id: UUID) -> Flow {
        items
            .value
            .first {
                $0.id == id
            }!
            .flow
    }
    
    @MainActor func search(string: String, id: UUID) async {
        guard let url = try? await cloud.search(string) else { return }
        
        switch flow(of: id) {
        case .list:
            await open(url: url, id: id)
        case let .web(web):
            web.load(url: url)
        case let .message(web, _, _, _):
            web.load(url: url)
            change(flow: .web(web), id: id)
        }
    }
    
    @MainActor func open(url: URL, change: Bool) async {
        let id = UUID()
        let web = await Web(status: self, item: id, settings: cloud.model.settings.configuration)
        let item = Item(id: id, flow: .web(web))
        web.load(url: url)
        if change {
            current.send(item.id)
        }
        items.value.append(item)
    }
    
    @MainActor func open(url: URL, id: UUID) async {
        let web: Web
        
        switch flow(of: id) {
        case .list:
            web = await .init(status: self, item: id, settings: cloud.model.settings.configuration)
        case let .web(item), let .message(item, _, _, _):
            web = item
        }
        
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
