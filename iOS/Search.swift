import SwiftUI
import Specs

struct Search: View {
    let representable: Representable
    let tab: () -> Void
    let access: (AccessType) -> Void
    @State private var complete = [Complete]()
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .ignoresSafeArea(edges: .horizontal)
            if complete.isEmpty {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.tertiary)
                    .font(.largeTitle)
                    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
                    .background(Color(.secondarySystemBackground))
                    .allowsHitTesting(false)
            } else {
                List(complete) { item in
                    Item(complete: item) {
                        UIApplication.shared.hide()
                        access(item.access)
                    }
                }
                .listStyle(.plain)
                .animation(.easeInOut(duration: 0.3), value: complete.count)
            }
        }
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
    
    private func autocomplete(string: String) async {
        complete = await cloud.autocomplete(search: string)
    }
}
