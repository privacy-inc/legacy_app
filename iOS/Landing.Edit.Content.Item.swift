import SwiftUI
import Specs

extension Landing.Edit.Content {
    struct Item: View {
        @State var active: Bool
        let id: Specs.Card.ID
        
        var body: some View {
            Toggle(isOn: $active) {
                Label("\(id)".capitalized, systemImage: symbol)
            }
            .onChange(of: active) { active in
                Task
                    .detached(priority: .utility) {
                        await cloud.turn(card: id, state: active)
                    }
            }
        }
        
        private var symbol: String {
            switch id {
            case .trackers:
                return "shield.lefthalf.filled"
            case .activity:
                return "chart.xyaxis.line"
            case .bookmarks:
                return "bookmark"
            case .history:
                return "clock"
            }
        }
    }
}
