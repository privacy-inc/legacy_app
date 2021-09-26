import SwiftUI

struct Tab: View {
    let web: Web
    let tabs: () -> Void
    let search: () -> Void
    
    var body: some View {
        web
            .edgesIgnoringSafeArea(.horizontal)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Bar(search: search) {
                    Button {
                        
                    } label: {
                        Image(systemName: "gear")
                            .symbolRenderingMode(.hierarchical)
                            .padding(.horizontal)
                    }
                    Spacer()
                } trailing: {
                    Spacer()
                    Button(action: tabs) {
                        Image(systemName: "square.on.square.dashed")
                            .symbolRenderingMode(.hierarchical)
                            .padding(.horizontal)
                    }
                }
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                Rectangle()
                    .fill(Color.secondary)
                    .frame(height: 0.5)
                    .edgesIgnoringSafeArea(.horizontal)
                    .background(.ultraThinMaterial)
            }
    }
}
