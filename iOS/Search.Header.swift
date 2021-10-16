import SwiftUI

extension Search {
    struct Header: View {
        let count: Int
        let tab: () -> Void
        @Environment(\.verticalSizeClass) private var vertical
        
        var body: some View {
            VStack(spacing: 0) {
                ZStack {
                    if count == 0 {
                        Text("Search or enter website")
                            .foregroundStyle(.tertiary)
                            .font(.footnote)
                            .allowsHitTesting(false)
                    } else {
                        Text("\(count.formatted()) found")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                            .font(.callout)
                            .allowsHitTesting(false)
                    }
                    Group {
                        Button(role: .cancel) {
                            UIApplication.shared.hide()
                            tab()
                        } label: {
                            Text("Cancel")
                                .font(.footnote)
                                .foregroundStyle(.primary)
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
                    .frame(height: 1)
                    .edgesIgnoringSafeArea(.horizontal)
                    .allowsHitTesting(false)
            }
            .background(.ultraThinMaterial)
        }
    }
}
