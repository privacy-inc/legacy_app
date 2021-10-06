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
            Tab(web: status[index].web!, tabs: tabs, search: search, open: url)
        case .search:
            Search(tab: tab, searching: searching)
                .equatable()
        case .tabs:
            Tabs(status: $status, transition: .init(index: index), tab: tab)
        }
    }
    
    private func tabs() {
        status[index].image = UIApplication.shared.snapshot
        flow = .tabs
    }
    
    private func search() {
        withAnimation(.spring()) {
            flow = .search
        }
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
                        await web()
                    } else {
                        history(try await cloud.search(search))
                    }
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
        if status[index].history == nil {
            withAnimation(.easeInOut(duration: 0.35)) {
                flow = .landing
            }
        } else {
            flow = .web
        }
    }
    
    private func web() async {
        if status[index].web == nil {
            status[index].web = await .init(history: status[index].history!, settings: cloud.model.settings.configuration)
        }
        
        flow = .web
        
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
