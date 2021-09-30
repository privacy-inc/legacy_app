import SwiftUI

struct Tab: View {
    let web: Web
    let tabs: () -> Void
    let search: () -> Void
    @State private var options = false
    @State private var progress = AnimatablePair(Double(), Double())
    
    var body: some View {
        web
            .edgesIgnoringSafeArea(.horizontal)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Bar(search: search) {
                    Button {
                        options = true
                    } label: {
                        Image(systemName: "ellipsis")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title2)
                            .frame(width: 70)
                    }
                    .sheet(isPresented: $options) {
                        Options(rootView: .init(web: web))
                            .edgesIgnoringSafeArea(.all)
                    }
                    
                    Spacer()
                } trailing: {
                    Spacer()
                    
                    Button(action: tabs) {
                        Image(systemName: "square.on.square.dashed")
                            .symbolRenderingMode(.hierarchical)
                            .frame(width: 70)
                    }
                }
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                VStack(spacing: 0) {
                    Loading(progress: progress)
                        .stroke(Color("Shades"), lineWidth: 2.5)
                        .frame(height: 2.5)
                    Rectangle()
                        .fill(Color.secondary)
                        .frame(height: 0.5)
                }
                .background(.ultraThinMaterial)
                .allowsHitTesting(false)
                .edgesIgnoringSafeArea(.horizontal)
                .onReceive(web.publisher(for: \.estimatedProgress)) { value in
                    progress.first = 0
                    withAnimation(.easeInOut(duration: 0.3)) {
                        progress.second = value
                    }
                    if value == 1 {
                        DispatchQueue
                            .main
                            .asyncAfter(deadline: .now() + 0.3) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    progress = .init(1, 1)
                                }
                            }
                    }
                }
            }
    }
}
