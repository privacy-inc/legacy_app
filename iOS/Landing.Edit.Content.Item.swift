import SwiftUI
import Specs

extension Landing.Edit.Content {
    struct Item: View {
        @State var active: Bool
        let id: Specs.Card.ID
        
        var body: some View {
            Toggle(isOn: $active) {
                Label(id.title, systemImage: id.symbol)
                    .padding([.trailing, .top, .bottom])
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .trailing)
            }
            .onChange(of: active) { active in
                Task
                    .detached(priority: .utility) {
                        await cloud.turn(card: id, state: active)
                    }
            }
        }
    }
}
