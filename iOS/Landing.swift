import SwiftUI

struct Landing: View {
    let tabs: () -> Void
    let search: () -> Void
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
                    Bookmarks()
                case .history:
                    History()
                }
            }
        }
        .background(.ultraThickMaterial)
        .safeAreaInset(edge: .bottom) {
            Bar(search: search) {
                Button {
                    
                } label: {
                    Image(systemName: "gear")
                        .symbolRenderingMode(.hierarchical)
                        .padding(.horizontal)
                }
                Spacer()
            } trailing: {
                Spacer()
                Button(action: tabs) {
                    Image(systemName: "square.on.square.dashed")
                        .symbolRenderingMode(.hierarchical)
                        .padding(.horizontal)
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
