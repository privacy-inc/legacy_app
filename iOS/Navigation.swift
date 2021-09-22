import SwiftUI

struct Navigation: View {
    @State private var flow = Flow.landing
    
    var body: some View {
        switch flow {
        case .landing:
            Landing(tabs: tabs)
        case .tabs:
            Tabs()
        case let .tab(id):
            Tab(id: id)
        case let .out(image):
            Out(image: image)
        default:
            Circle()
        }
    }
    
    private func tabs() {
        flow = .out(UIApplication.shared.snapshot)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.2)) {
                flow = .tabs
            }
        }
    }
}
