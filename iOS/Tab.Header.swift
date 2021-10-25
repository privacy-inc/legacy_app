import SwiftUI

extension Tab {
    struct Header: View {
        let web: Web
        @State private var color = Color(.secondarySystemBackground)
        @State private var progress = AnimatablePair(Double(), Double())
        
        var body: some View {
            VStack(spacing: 0) {
                Loading(progress: progress)
                    .stroke(color, lineWidth: 2)
                    .frame(height: 2)
                Divider()
            }
            .colorInvert()
            .foregroundStyle(.secondary)
            .background(color)
            .allowsHitTesting(false)
            .ignoresSafeArea(edges: .horizontal)
            .onReceive(web.publisher(for: \.estimatedProgress), perform: progress(value:))
            .onReceive(web.publisher(for: \.underPageBackgroundColor)) {
                color = .init($0)
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
}
