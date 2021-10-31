import Foundation
import Combine

struct Status {
    let current: CurrentValueSubject<UUID, Never>
    let flows: CurrentValueSubject<[Item], Never>

    init() {
        let item = Item(flow: .landing)
        flows = .init([item])
        current = .init(item.id)
    }
    
    func addTab() {
        let item = Item(flow: .landing)
        flows.value.append(item)
        current.send(item.id)
    }
    
    func close(id: UUID) {
        guard flows.value.count > 1 else { return }
        
        if current.value == id {
            let index = self.index
            if index > 0 {
                current.value = flows.value[index - 1].id
            } else {
                current.value = flows.value[index + 1].id
            }
        }
        
        flows
            .value
            .remove {
                $0.id == id
            }
            .map {
                switch $0.flow {
                case let .web(web), let .error(web, _):
                    web.clear()
                default:
                    break
                }
            }
    }
    
    @MainActor func searching(search: String) async {
        do {
            switch item.flow {
            case .landing:
                try await history(cloud.search(search))
            case let .web(web), let .error(web, _):
                try await cloud.search(search, history: web.history)
                await web.access()
            }
        } catch {
            fatalError()
        }
    }
    
    private func history(_ id: UInt16) async {
        let web = await Web(history: id, settings: cloud.model.settings.configuration)
        change(flow: .web(web))
        await web.access()
    }
    
    private var item: Item {
        flows
            .value
            .first {
                $0.id == current.value
            }!
    }
    
    private var index: Int {
        flows
            .value
            .firstIndex {
                $0.id == current.value
            }!
    }
    
    private func change(flow: Flow) {
        flows.value[index].flow = flow
    }
}
