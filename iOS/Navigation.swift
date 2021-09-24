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
        case .web:
            Tab(tabs: tabs, search: search)
        case .search:
            Search(tab: tab)
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
    
    private func tab(_ index: Int) {
//        if status[index].browse == nil {
//            flow = .landing(index)
//        } else {
            flow = .web(index)
//        }
    }
}
