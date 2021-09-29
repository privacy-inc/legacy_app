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
                        Image(systemName: "chevron.backward")
                            .frame(width: 60)
                    }
                    Button {
                        
                    } label: {
                        Image(systemName: "chevron.forward")
                            .frame(width: 60)
                    }
                    Spacer()
                } trailing: {
                    Spacer()
                    Button(action: tabs) {
                        Image(systemName: "ellipsis.circle")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title2)
                            .frame(width: 60)
                    }
                    Button(action: tabs) {
                        Image(systemName: "square.on.square.dashed")
                            .symbolRenderingMode(.hierarchical)
                            .frame(width: 60)
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
