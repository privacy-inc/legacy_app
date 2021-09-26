import SwiftUI

struct Navigation: View {
    @State private var flow = Flow.landing(0)
    @State private var status = [Status()]
    
    var body: some View {
        switch flow {
        case .menu:
            Circle()
        case .landing:
            Landing(tabs: tabs, search: search)
        case let .web(index):
            Tab(web: status[index].web!, tabs: tabs, search: search)
        case .search:
            Search(tab: tab, searching: searching)
                .equatable()
        case let .tabs(index):
            Tabs(status: $status, transition: .init(index: index), tab: tab)
        }
    }
    
    private func tabs() {
        status[flow.index].image = UIApplication.shared.snapshot
        flow = .tabs(flow.index)
    }
    
    private func tab() {
        withAnimation(.easeInOut(duration: 0.3)) {
            tab(flow.index)
        }
    }
    
    private func search() {
        withAnimation(.easeInOut(duration: 0.4)) {
            flow = .search(flow.index)
        }
    }
    
    private func searching(search: String) {
        Task
            .detached(priority: .utility) {
                do {
                    if let id = status[flow.index].history {
                        try await cloud.search(search, history: id)
                    } else {
                        status[flow.index].history = try await cloud.search(search)
                    }
                    
                    let history = await cloud.model.history
                        .first {
                            $0.id == status[flow.index].history
                        }!
                    
                    if status[flow.index].web == nil {
                        status[flow.index].web = await .init(history: status[flow.index].history!)
                    }
                    
                    await status[flow.index].web!.load(history.website.access)
                    
                    tab()
                } catch {
                    tab()
                }
        }
    }
    
    private func tab(_ index: Int) {
        if status[index].history == nil {
            flow = .landing(index)
        } else {
            flow = .web(index)
        }
    }
}
