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
        case .tab:
            Tab(tabs: tabs)
        case .search:
            Search()
        case let .tabs(index):
            Tabs(status: $status, transition: .init(index: index), tab: tab)
        }
    }
    
    private func tabs() {
        switch flow {
        case let .landing(index), let .tab(index):
            status[index].image = UIApplication.shared.snapshot
            flow = .tabs(index)
        default:
            break
        }
    }
    
    private func search() {
        switch flow {
        case let .landing(index), let .tab(index):
            flow = .search(index)
        default:
            break
        }
    }
    
    private func tab(_ index: Int) {
        if status[index].browse == nil {
            flow = .landing(index)
        } else {
            flow = .tabs(index)
        }
    }
}
