import SwiftUI
import Specs

struct Navigation: View {
    @State private var flow = Flow.landing
    @State private var index = 0
    @State private var status = [Status()]
    
    var body: some View {
        switch flow {
        case .landing:
            Landing(tabs: tabs, search: search, history: history, access: access)
        case .web:
            Tab(web: status[index].web!, tabs: tabs, search: search, find: find, open: url, error: error)
        case .search:
            Search(tab: tab, searching: searching)
                .equatable()
        case .tabs:
            Tabs(status: $status, transition: .init(index: index), tab: index)
        case .find:
            Find(web: status[index].web!, end: end)
        case .error:
            Recover(url: status[index].error?.url.absoluteString ?? "", description: status[index].error?.description ?? "", tabs: tabs, search: search, dismiss: dismiss, retry: retry)
        }
    }
    
    private func tabs() {
        status[index].image = UIApplication.shared.snapshot
        flow = .tabs
    }
    
    private func search() {
        animate(to: .search)
    }
    
    private func find() {
        animate(to: .find)
    }
    
    private func end() {
        animate(to: .web)
    }
    
    private func tab() {
        if status[index].error != nil {
            animate(to: .error)
        } else if status[index].history != nil {
            flow = .web
        } else {
            animate(to: .landing)
        }
    }
    
    private func web() async {
        if status[index].web == nil {
            status[index].web = await .init(history: status[index].history!, settings: cloud.model.settings.configuration)
        }
        
        flow = .web
        
        await status[index].web!.load(cloud
                                        .website(history: status[index].history!)
                                        .access)
    }
    
    private func dismiss() {
        status[index].error = nil
        
        if status[index].web?.url == nil {
            status[index].history = nil
            status[index].web = nil
        } else {
            status[index].web?.reload()
        }
        
        tab()
    }
    
    private func retry() {
        let url = status[index].error!.url
        status[index].error = nil
        status[index].web?.load(url)
        tab()
    }
    
    private func url(_ url: URL) {
        Task {
            status.append(.init())
            index = status.count - 1
            history(await cloud.open(url: url))
        }
    }
    
    private func access(_ access: AccessType) {
        Task {
            history(await cloud.open(access: access))
        }
    }
    
    private func history(_ id: UInt16) {
        status[index].history = id
        
        Task {
            await web()
        }
    }
    
    private func searching(search: String) {
        Task
            .detached(priority: .utility) {
                do {
                    if let id = status[index].history {
                        try await cloud.search(search, history: id)
                        status[index].error = nil
                        await web()
                    } else {
                        history(try await cloud.search(search))
                    }
                } catch {
                    animate(to: .landing)
                }
        }
    }
    
    private func error(_ error: Err) {
        status[index].error = error
        tab()
    }
    
    private func animate(to: Flow) {
        withAnimation(.easeInOut(duration: 0.35)) {
            flow = to
        }
    }
    
    private func index(_ index: Int, search: Bool) {
        self.index = index
        if search {
            animate(to: .search)
        } else {
            tab()
        }
    }
}
