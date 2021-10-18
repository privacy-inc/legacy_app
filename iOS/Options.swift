import SwiftUI

struct Options: View {
    let web: Web
    let find: () -> Void
    @State private var options = false
    
    var body: some View {
        Button {
            UIApplication.shared.hide()
            options = true
        } label: {
            Image(systemName: "ellipsis")
                .symbolRenderingMode(.hierarchical)
                .font(.title)
                .frame(width: 70, height: 34)
                .allowsHitTesting(false)
        }
        .sheet(isPresented: $options) {
            Representable(web: web, find: find)
                .ignoresSafeArea(edges: .all)
        }
    }
}
