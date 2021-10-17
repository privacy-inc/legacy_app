import SwiftUI

extension Search {
    struct Header: View {
        let count: Int
        let tab: () -> Void
        @Environment(\.verticalSizeClass) private var vertical
        
        var body: some View {
            ZStack {
                if count == 0 {
                    Text("Search or enter website")
                        .foregroundStyle(.secondary)
                        .allowsHitTesting(false)
                } else {
                    Text("\(count.formatted()) found")
                        .monospacedDigit()
                        .foregroundStyle(.primary)
                        .allowsHitTesting(false)
                }
                Group {
                    Button(role: .cancel) {
                        UIApplication.shared.hide()
                        tab()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(.primary)
                            .padding(.horizontal)
                            .padding(.vertical, 14)
                    }
                }
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .trailing)
            }
            .font(.callout)
            .animation(.easeInOut(duration: 0.3), value: count)
            .background(.ultraThinMaterial)
        }
    }
}
