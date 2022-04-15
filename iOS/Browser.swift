import SwiftUI

struct Browser: View {
    let web: Web
    @State private var progress = AnimatablePair(Double(), Double())
    
    var body: some View {
        web
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Bar(leading:
                        .init(icon: "line.3.horizontal", action: {
                            
                        }),
                    center:
                        .init(icon: "magnifyingglass", action: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                web.session.change(flow: .search(true), of: web.id)
                            }
                        }),
                    trailing:
                        .init(icon: "square.on.square", action: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                web.session.current = .tabs
                            }
                        }),
                    material: .thin)
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                VStack(spacing: 0) {
                    Progress(progress: progress)
                        .stroke(Color("Shades"), style: .init(lineWidth: 3, lineCap: .round))
                        .frame(height: 2)
                    Divider()
                }
                .background(.thinMaterial)
                .allowsHitTesting(false)
                .onReceive(web.progress, perform: progress(value:))
            }
    }
    
    private func progress(value: Double) {
        guard value != 1 || progress.second != 0 else { return }
        
        progress.first = 0
        withAnimation(.easeInOut(duration: 0.5)) {
            progress.second = value
        }
        
        if value == 1 {
            DispatchQueue
                .main
                .asyncAfter(deadline: .now() + 0.7) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        progress = .init(1, 1)
                    }
                }
        }
    }
}
