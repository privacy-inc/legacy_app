import SwiftUI
import Specs

struct Landing: View {
    let tabs: () -> Void
    let search: () -> Void
    let history: (Int) -> Void
    let url: (URL) -> Void
    @State private var sidebar = false
    @State private var cards = [Cards.report,
                                .activity,
                                .bookmarks,
                                .history]
    
    var body: some View {
        ScrollView {
            ForEach(cards) {
                switch $0 {
                case .report:
                    Report()
                case .activity:
                    Activity()
                case .bookmarks:
                    Bookmarks(select: url)
                case .history:
                    History(select: history)
                }
            }
        }
        .clipped()
        .background(.ultraThickMaterial)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Bar(search: search) {
                Button {
                    sidebar = true
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title3)
                        .symbolRenderingMode(.hierarchical)
                        .frame(width: 70)
                        .allowsHitTesting(false)
                }
                .sheet(isPresented: $sidebar) {
                    Sidebar(presented: $sidebar, url: url)
                }
                
                Spacer()
            } trailing: {
                Spacer()
                Button(action: tabs) {
                    Image(systemName: "square.on.square.dashed")
                        .symbolRenderingMode(.hierarchical)
                        .frame(width: 70)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

enum Cards: Identifiable {
    var id: Self {
        self
    }
    
    case
    report,
    activity,
    bookmarks,
    history
}
