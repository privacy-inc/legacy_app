import SwiftUI
import Specs

struct Status {
    var index: Int? = 0
    var flow = Flow.landing
    var items = [Item()]
    
    var item: Item? {
        get {
            index
                .map {
                    items[$0]
                }
        }
        set {
            guard
                let index = index,
                let item = newValue
            else { return }
            items[index] = item
        }
    }
    
    mutating func tab() {
        if item!.error != nil {
            animate(to: .error)
        } else if item!.history != nil {
            flow = .web
        } else {
            animate(to: .landing)
        }
    }
    
    mutating func add() {
        items.append(.init())
        index = items.count - 1
        animate(to: .search)
    }
    
    mutating func web() async {
        item!.error = nil
        
        if item!.web == nil {
            item!.web = await .init(history: item!.history!, settings: cloud.model.settings.configuration)
        }
        
        flow = .web
        
        if let access = await cloud
            .website(history: item!.history!)?
            .access {
            
            await item!.web!.load(access)
        }
    }
    
    mutating func dismiss() async {
        item!.error = nil
        
        if let history = item!.history,
           let url = await item!.web?.url,
           let title = await item!.web?.title {
            
            await cloud.update(url: url, history: history)
            await cloud.update(title: title, history: history)
        } else {
            item!.history = nil
            item!.web = nil
        }
        
        tab()
    }
    
    @MainActor mutating func url(_ url: URL) async {
        if item?.web != nil || item?.history != nil {
            items.append(.init())
            index = items.count - 1
        }
        await history(cloud.open(url: url))
    }
    
    mutating func history(_ id: UInt16) async {
        item!.history = id
        await web()
    }
    
    mutating func access(_ access: AccessType) async {
        if let id = item!.history {
            await cloud.open(access: access, history: id)
            await web()
        } else {
            await history(cloud.open(access: access))
        }
    }
    
    mutating func searching(search: String) async {
        do {
            if let id = item!.history {
                try await cloud.search(search, history: id)
                await web()
            } else {
                try await history(cloud.search(search))
            }
        } catch {
            animate(to: .landing)
        }
    }
    
    mutating func animate(to: Flow) {
        withAnimation(.easeInOut(duration: 0.35)) {
            flow = to
        }
    }
}
