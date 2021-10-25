import SwiftUI
import Specs

struct Tab: View {
    let web: Web
    let tabs: () -> Void
    let search: () -> Void
    let find: () -> Void
    let open: (URL) -> Void
    let error: (Err) -> Void
    
    var body: some View {
        web
            .equatable()
            .ignoresSafeArea(edges: .horizontal)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Bar(search: search) {
                    Options(web: web, find: find)
                    
                    Spacer()
                } trailing: {
                    Spacer()
                    
                    Button(action: tabs) {
                        Image(systemName: "square.on.square.dashed")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title3)
                            .frame(width: 70, height: 34)
                            .allowsHitTesting(false)
                    }
                }
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                Header(web: web)
            }
            .ignoresSafeArea(.keyboard)
            .onReceive(web.tab) { url in
                tabs()
                
                DispatchQueue
                    .main
                    .asyncAfter(deadline: .now() + 0.4) {
                        open(url)
                    }
            }
            .onReceive(web.error) {
                error($0)
            }
    }
}
