import SwiftUI

extension Detail {
    struct Navigation: View {
        let web: Web
        @State private var back = false
        @State private var forward = false
        @State private var loading = false
        
        var body: some View {
            HStack(spacing: 0) {
                Bar.Item(icon: "chevron.backward") {
                    web.goBack()
                }
                .foregroundStyle(back ? .primary : .tertiary)
                .allowsHitTesting(back)
                
                Spacer()
                Bar.Item(icon: loading ? "xmark" : "arrow.clockwise") {
                    if loading {
                        web.stopLoading()
                    } else {
                        web.reload()
                    }
                }
                Spacer()
                Bar.Item(icon: "chevron.forward") {
                    web.goForward()
                }
                .foregroundStyle(forward ? .primary : .tertiary)
                .allowsHitTesting(forward)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .onReceive(web.publisher(for: \.canGoBack)) {
                back = $0
            }
            .onReceive(web.publisher(for: \.canGoForward)) {
                forward = $0
            }
            .onReceive(web.publisher(for: \.isLoading)) {
                loading = $0
            }
        }
    }
}
