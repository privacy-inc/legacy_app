import SwiftUI

struct Navigation: View {
    @State private var flow = Flow.landing
    
    var body: some View {
        switch flow {
        case .landing:
            Landing()
        case .tabs:
            Tabs()
        case let .tab(id):
            Tab(id: id)
        default:
            Circle()
        }
    }
}
