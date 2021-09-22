import SwiftUI

struct Navigation: View {
    @State private var flow = Flow.landing(0)
    @State private var status = [Status()]
    
    var body: some View {
        switch flow {
        case .menu:
            Circle()
        case let .landing(index):
            Landing(tabs: tabs)
        case let .tab(index):
            Tab(index: index)
        case let .tabs(index):
            Tabs(status: $status, minimize: .init(index: index))
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
}
