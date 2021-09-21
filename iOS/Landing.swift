import SwiftUI

struct Landing: View {
    @State private var cards = [Cards.report,
                                .activity,
                                .history,
                                .bookmarks]
    
    var body: some View {
        ScrollView {
            ForEach(cards) {
                switch $0 {
                case .report:
                    Report()
                default:
                    History()
                }
            }
        }
        .background(.ultraThickMaterial)
        .safeAreaInset(edge: .bottom, content: Bar.init)
    }
}

enum Cards: Identifiable {
    var id: Self {
        self
    }
    
    case
    report,
    activity,
    history,
    bookmarks
}
