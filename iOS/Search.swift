import SwiftUI
import Specs

struct Search: View {
    let representable: Representable
    let tab: () -> Void
    let access: (AccessType) -> Void
    @State private var complete = [Complete]()
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .foregroundStyle(.tertiary)
                .frame(height: 1)
                .edgesIgnoringSafeArea(.horizontal)
                .allowsHitTesting(false)
            if complete.isEmpty {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.tertiary)
                    .font(.largeTitle)
                    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .center)
                    .background(Color(.secondarySystemBackground))
                    .allowsHitTesting(false)
            } else {
                List(complete) { item in
                    Item(complete: item) {
                        UIApplication.shared.hide()
                        access(item.access)
                    }
                }
                .listStyle(.grouped)
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
