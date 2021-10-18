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
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .allowsHitTesting(false)
                } else {
                    Text("\(count.formatted()) found")
                        .font(.callout)
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
                            .font(.body)
                            .foregroundStyle(.primary)
                            .padding()
                    }
                }
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .trailing)
            }
            .animation(.easeInOut(duration: 0.3), value: count)
            .background(.ultraThinMaterial)
        }
    }
}
