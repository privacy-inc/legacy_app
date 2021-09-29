import SwiftUI

struct Tab: View {
    let web: Web
    let tabs: () -> Void
    let search: () -> Void
    @State private var options = false
    
    var body: some View {
        web
            .edgesIgnoringSafeArea(.horizontal)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Bar(search: search) {
                    Button {
                        
                    } label: {
                        Image(systemName: "chevron.backward")
                            .frame(width: 64)
                    }
                    Button {
                        
                    } label: {
                        Image(systemName: "chevron.forward")
                            .frame(width: 64)
                    }
                    Spacer()
                } trailing: {
                    Spacer()
                    
                    Button {
                        options = true
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title2)
                            .frame(width: 64)
                    }
                    .sheet(isPresented: $options) {
                        Options(rootView: .init(web: web))
                            .edgesIgnoringSafeArea(.all)
                    }
                    
                    Button(action: tabs) {
                        Image(systemName: "square.on.square.dashed")
                            .symbolRenderingMode(.hierarchical)
                            .frame(width: 64)
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
