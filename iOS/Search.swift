import SwiftUI

struct Search: View {
    let tab: () -> Void
    
    var body: some View {
        VStack {
            Representable()
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .background(.ultraThickMaterial)
        .safeAreaInset(edge: .bottom) {
            Bar()
        }
        .safeAreaInset(edge: .top) {
            Header(tab: tab)
        }
    }
}
