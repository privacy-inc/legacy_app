import SwiftUI

struct Tab: View {
    let tabs: () -> Void
    
    var body: some View {
        VStack {
            Text("hello world")
        }
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background(.ultraThickMaterial)
        .safeAreaInset(edge: .bottom) {
            Bar(tabs: tabs)
        }
    }
}
