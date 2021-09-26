import SwiftUI

struct Navigation: View {
    @State private var flow = Flow.landing(0)
    @State private var status = [Status()]
    @State private var webs = [Int : Web]()
    
    var body: some View {
        switch flow {
        case .menu:
            Circle()
        case .landing:
            Landing(tabs: tabs, search: search)
        case let .web(index):
            Tab(history: status[index].history!, tabs: tabs, search: search)
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
        Task {
            if let history = await cloud.search(search) {
                status[flow.index].history = history
            }
            tab()
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
