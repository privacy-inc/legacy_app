import SwiftUI
import Specs

struct Landing: View {
    let tabs: () -> Void
    let search: () -> Void
    let clear: () -> Void
    let history: (UInt16) -> Void
    let access: (AccessType) -> Void
    @State private var sidebar = false
    @State private var cards = [Specs.Card]()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(cards) {
                switch $0.id {
                case .trackers:
                    Trackers()
                case .activity:
                    Activity()
                case .bookmarks:
                    Bookmarks(select: access)
                case .history:
                    History(select: history)
                }
            }
            .animation(.easeInOut(duration: 0.45), value: cards)
            Edit()
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .background(.ultraThickMaterial)
        .onReceive(cloud) {
            cards = $0
                .cards
                .filter(\.state)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Bar(search: search) {
                Button {
                    sidebar = true
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title2)
                        .frame(width: 70, height: 34)
                        .allowsHitTesting(false)
                }
                .sheet(isPresented: $sidebar) {
                    Sidebar(presented: $sidebar, clear: clear, access: access, history: history)
                }
                
                Spacer()
            } trailing: {
                Spacer()
                Button(action: tabs) {
                    Image(systemName: "square.on.square.dashed")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title3)
                        .frame(width: 70, height: 34)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}
