import SwiftUI
import Specs

struct Tab: View {
    let web: Web
    let tabs: () -> Void
    let search: () -> Void
    let find: () -> Void
    let open: (URL) -> Void
    let error: (Err) -> Void
    @State private var options = false
    @State private var progress = AnimatablePair(Double(), Double())
    
    var body: some View {
        web
            .equatable()
            .edgesIgnoringSafeArea(.horizontal)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Bar(search: search) {
                    Button {
                        UIApplication.shared.hide()
                        options = true
                    } label: {
                        Image(systemName: "ellipsis")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title3)
                            .frame(width: 70)
                            .allowsHitTesting(false)
                    }
                    .sheet(isPresented: $options) {
                        Options(web: web, find: find)
                            .edgesIgnoringSafeArea(.all)
                    }
                    
                    Spacer()
                } trailing: {
                    Spacer()
                    
                    Button(action: tabs) {
                        Image(systemName: "square.on.square.dashed")
                            .symbolRenderingMode(.hierarchical)
                            .font(.callout)
                            .frame(width: 70)
                            .allowsHitTesting(false)
                    }
                }
                .offset(y: options ? 85 : 0)
                .animation(.easeInOut(duration: 0.2), value: options)
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                VStack(spacing: 0) {
                    Loading(progress: progress)
                        .stroke(Color(web.underPageBackgroundColor), lineWidth: 2)
                        .frame(height: 2)        
                    Rectangle()
                        .foregroundStyle(Color(web.underPageBackgroundColor).opacity(0.15))
                        .frame(height: 1)
                }
                .colorInvert()
                .foregroundStyle(.secondary)
                .background(Color(web.underPageBackgroundColor))
                .allowsHitTesting(false)
                .edgesIgnoringSafeArea(.horizontal)
            }
            .onReceive(web.publisher(for: \.estimatedProgress), perform: progress(value:))
            .onReceive(web.tab) { url in
                tabs()
                
                DispatchQueue
                    .main
                    .asyncAfter(deadline: .now() + 0.5) {
                        open(url)
                    }
            }
            .onReceive(web.error) {
                error($0)
            }
    }
    
    private func progress(value: Double) {
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
