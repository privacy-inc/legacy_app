import SwiftUI

extension Search {
    struct Header: View {
        let tab: () -> Void
        @Environment(\.verticalSizeClass) private var vertical
        
        var body: some View {
            VStack(spacing: 0) {
                ZStack {
                    Image(systemName: "magnifyingglass")
                        .allowsHitTesting(false)
                    Group {
                        Button(role: .cancel) {
                            UIApplication.shared.hide()
                            tab()
                        } label: {
                            Text("Cancel")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)
                                .padding(.vertical, 6)
                        }
                    }
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .trailing)
                }
                .padding(.top, 2)
                .padding(.bottom, vertical == .compact ? 0 : 6)
                
                Rectangle()
                    .fill(Color.secondary)
                    .frame(height: 0.5)
                    .edgesIgnoringSafeArea(.horizontal)
                    .allowsHitTesting(false)
            }
            .background(.ultraThinMaterial)
        }
    }
}
