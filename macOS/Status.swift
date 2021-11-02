import Foundation
import Combine
import Specs

struct Status {
    let current: CurrentValueSubject<UUID, Never>
    let items: CurrentValueSubject<[Item], Never>

    init() {
        self.init(item: .init(flow: .landing))
    }
    
    init(item: Item) {
        items = .init([item])
        current = .init(item.id)
    }
    
    func addTab() {
        let item = Item(flow: .landing)
        items.value.append(item)
        current.send(item.id)
    }
    
    func close(id: UUID) {
        guard items.value.count > 1 else { return }
        
        if current.value == id {
            shift()
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
            shift()
        }
        
        Window.new(status: .init(item: items
                                    .value
                                    .remove {
                                        $0.id == id
                                    }!))
    }
    
    @MainActor func searching(search: String) async {
        do {
            switch item.flow {
            case .landing:
                try await history(id: cloud.search(search))
            case let .web(web), let .error(web, _):
                try await cloud.search(search, history: web.history)
                await web.access()
            }
        } catch {
            fatalError()
        }
    }
    
    @MainActor func access(access: AccessType) async {
        switch item.flow {
        case .landing:
            await history(id: cloud.open(access: access))
        case let .web(web), let .error(web, _):
            await cloud.open(access: access, history: web.history)
            await web.access()
        }
    }
    
    @MainActor func history(id: UInt16) async {
        let web = await Web(history: id, settings: cloud.model.settings.configuration)
        change(flow: .web(web))
        await web.access()
    }
    
    private var item: Item {
        items
            .value
            .first {
                $0.id == current.value
            }!
    }
    
    private var index: Int {
        items
            .value
            .firstIndex {
                $0.id == current.value
            }!
    }
    
    private func change(flow: Flow) {
        items.value[index].flow = flow
    }
    
    private func shift() {
        let index = self.index
        if index > 0 {
            current.value = items.value[index - 1].id
        } else {
            current.value = items.value[index + 1].id
        }
    }
}
