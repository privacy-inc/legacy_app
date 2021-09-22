import SwiftUI

struct Tabs: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(0 ..< 5) {
                    Item(index: $0)
                }
            }
            .padding(.horizontal, 40)
            .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        }
        .background(LinearGradient(gradient: .init(colors: [.init(.systemFill), .init(.secondarySystemFill)]),
                                   startPoint: .bottom, endPoint: .top))
        .navigationTitle("Tabs")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                NavigationLink(destination: Tab(id: .init())) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .symbolRenderingMode(.hierarchical)
                }
                .foregroundColor(.init("Shades"))
            }
        }
    }
}
