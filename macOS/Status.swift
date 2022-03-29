import Foundation
import Combine
import Specs

final class Status {
    let current: CurrentValueSubject<UUID, Never>
    let items: CurrentValueSubject<[Item], Never>
    let search = PassthroughSubject<Void, Never>()
    let widthOn = CurrentValueSubject<CGFloat, Never>(0)
    let widthOff = CurrentValueSubject<CGFloat, Never>(0)

    var item: Item {
        items
            .value
            .first {
                $0.id == current.value
            }!
    }
    
    convenience init() {
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
    
    func dismiss() async {
        guard
            case let .error(web, _) = item.flow,
            let url = await web.url,
            let title = await web.title
        else {
            let current = current.value
            addTab()
            close(id: current)
            return
        }
        
        await cloud.update(url: url, history: web.history)
        await cloud.update(title: title, history: web.history)
        await change(flow: .web(web))
    }
    
    func nextTab() {
        let index = index
        if index > 0 {
            current.value = items.value[index - 1].id
        } else {
            current.value = items.value.last!.id
        }
    }
    
    func previousTab() {
        let index = index
        if index < items.value.count - 1 {
            current.value = items.value[index + 1].id
        } else {
            current.value = items.value.first!.id
        }
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
        
        Window(status: .init(item: items
            .value
            .remove {
                $0.id == id
            }!))
    }
    
    @MainActor func change(flow: Flow, id: UUID) {
        items
            .value
            .firstIndex {
                $0.id == id
            }
            .map { index in
                items.value[index].flow = flow
            }
    }
    
    @MainActor func searching(search: String) async {
        do {
            switch item.flow {
            case .landing:
                try await history(id: cloud.search(search))
            case let .web(web):
                try await cloud.search(search, history: web.history)
                await web.access()
            case let .error(web, _):
                try await cloud.search(search, history: web.history)
                await web.access()
                change(flow: .web(web))
            }
        } catch {
            
        }
    }
    
    @MainActor func url(url: URL) async {
        await open(id: await cloud.open(url: url))
    }
    
    @MainActor func silent(url: URL) async {
        let web = await Web(status: self, item: .init(), history: cloud.open(url: url), settings: cloud.model.settings.configuration)
        items.value.append(.init(id: web.item, web: web))
        await web.access()
        current.send(current.value)
    }
    
    @MainActor func access(access: any AccessType) async {
        await open(id: cloud.open(access: access))
    }
    
    @MainActor func reaccess(access: AccessType) async {
        switch item.flow {
        case .landing:
            await history(id: cloud.open(access: access))
        case let .web(web):
            await cloud.open(access: access, history: web.history)
            await web.access()
        case let .error(web, _):
            await cloud.open(access: access, history: web.history)
            await web.access()
            change(flow: .web(web))
        }
    }
    
    @MainActor func open(id: UInt16) async {
        switch item.flow {
        case .landing:
            await history(id: id)
        case .web, .error:
            let web = await Web(status: self, item: .init(), history: id, settings: cloud.model.settings.configuration)
            let item = Item(id: web.item, web: web)
            items.value.append(item)
            current.send(web.item)
            await web.access()
        }
    }
    
    private var index: Int {
        items
            .value
            .firstIndex {
                $0.id == current.value
            }!
    }
    
    @MainActor private func history(id: UInt16) async {
        let web = await Web(status: self, item: current.value, history: id, settings: cloud.model.settings.configuration)
        change(flow: .web(web))
        await web.access()
    }
    
    @MainActor private func change(flow: Flow) {
        items.value[index].flow = flow
    }
    
    private func shift() {
        let index = index
        if index > 0 {
            current.value = items.value[index - 1].id
        } else {
            current.value = items.value[index + 1].id
        }
    }
}
