import SwiftUI

struct Navigation: View {
    @State private var flow = Flow.landing
    @State private var index = 0
    @State private var status = [Status()]
    
    var body: some View {
        switch flow {
        case .settings:
            Settings(tab: tab)
        case .landing:
            Landing(tabs: tabs, search: search, settings: settings, history: history, url: url)
        case .web:
            Tab(web: status[index].web!, tabs: tabs, search: search)
        case .search:
            Search(tab: tab, searching: searching)
                .equatable()
        case .tabs:
            Tabs(status: $status, transition: .init(index: index), tab: tab)
        }
    }
    
    private func settings() {
        withAnimation(.easeInOut(duration: 0.4)) {
            flow = .settings
        }
    }
    
    private func tabs() {
        status[index].image = UIApplication.shared.snapshot
        flow = .tabs
    }
    
    private func search() {
        withAnimation(.easeInOut(duration: 0.4)) {
            flow = .search
        }
    }
    
    private func url(_ url: URL) {
        Task {
            status[index].history = await cloud.open(url: url)
            await prepare()
            flow = .web
            await load()
        }
    }
    
    private func history(_ id: Int) {
        status[index].history = id
        
        Task {
            await prepare()
            flow = .web
            await load()
        }
    }
    
    private func searching(search: String) {
        Task
            .detached(priority: .utility) {
                do {
                    if let id = status[index].history {
                        try await cloud.search(search, history: id)
                    } else {
                        status[index].history = try await cloud.search(search)
                    }
                    
                    await prepare()
                    tab()
                    await load()
                } catch {
                    tab()
                }
        }
    }
    
    private func tab(_ index: Int) {
        self.index = index
        tab()
    }
    
    private func tab() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if status[index].history == nil {
                flow = .landing
            } else {
                flow = .web
            }
        }
    }
    
    private func prepare() async {
        let settings = await cloud.model.settings
        if status[index].web == nil {
            status[index].web = await .init(history: status[index].history!, settings: settings)
        }
    }
    
    private func load() async {
        await status[index].web!.load(cloud
                                        .model
                                        .history
                                        .first {
                                            $0.id == status[index].history
                                        }!
                                        .website
                                        .access)
    }
}
