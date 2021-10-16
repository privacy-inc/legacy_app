import SwiftUI
import Specs

struct Search: View {
    let representable: Representable
    let tab: () -> Void
    let access: (AccessType) -> Void
    @State private var complete = [Complete]()
    
    var body: some View {
        List(complete) { item in
            Item(complete: item) {
                UIApplication.shared.hide()
                access(item.access)
            }
        }
        .listStyle(.grouped)
        .animation(.easeInOut(duration: 0.3), value: complete.count)
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
}
