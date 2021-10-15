import SwiftUI
import Specs

struct Search: View, Equatable {
    let tab: () -> Void
    let representable: Representable
    @State private var complete = [Complete]()
    
    var body: some View {
        List(complete) {
            Text(verbatim: $0.title)
        }
        .listStyle(.grouped)
        .safeAreaInset(edge: .top, spacing: 0) {
            Header(count: complete.count, tab: tab)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            representable
                .equatable()
                .frame(height: 1)
        }
        .onReceive(representable.autocomplete) { complete in
            Task {
                await autocomplete(string: complete)
            }
        }
    }
    
    private var separator: some View {
        Rectangle()
            .fill(Color.primary.opacity(0.05))
            .frame(height: 1)
            .padding(.leading, 40)
            .padding(.trailing, 2)
    }
    
    private func autocomplete(string: String) async {
        complete = await cloud.autocomplete(search: string)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}
