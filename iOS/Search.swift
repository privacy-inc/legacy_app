import SwiftUI

struct Search: View {
    let tab: () -> Void
    
    var body: some View {
        ScrollView {
            Representable()
                .frame(height: 1)
            ForEach(0 ..< 20) {
                Text("\($0)")
                    .padding()
            }
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .background(.ultraThickMaterial)
        .safeAreaInset(edge: .top) {
            Header(tab: tab)
        }
    }
}
