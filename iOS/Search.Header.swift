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
                            .foregroundStyle(.secondary)
                            .font(.callout)
                            .allowsHitTesting(false)
                    } else {
                        Text("\(count.formatted()) similar")
                            .monospacedDigit()
                            .foregroundStyle(.primary)
                            .font(.callout)
                            .allowsHitTesting(false)
                    }
                    Group {
                        Button(role: .cancel) {
                            UIApplication.shared.hide()
                            tab()
                        } label: {
                            Text("Cancel")
                                .font(.callout)
                                .foregroundStyle(.primary)
                                .padding(.horizontal)
                                .padding(.vertical, 14)
                        }
                    }
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .trailing)
                }
                .animation(.easeInOut(duration: 0.3), value: count)
                
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
