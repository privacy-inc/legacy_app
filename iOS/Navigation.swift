import SwiftUI

struct Navigation: View {
    @State var flow: Flow
    
    var body: some View {
        switch flow {
        case let .tab(id):
            NavigationView {
                Tab(id: id, tabs: tabs)
            }
            .navigationViewStyle(.stack)
        case let .tabs(last):
            NavigationView {
                Tabs()
            }
            .navigationViewStyle(.columns)
        }
    }
    
    private func tabs() {
        withAnimation(.easeInOut(duration: 3)) {
            flow = .tabs(flow.id)
        }
    }
}
