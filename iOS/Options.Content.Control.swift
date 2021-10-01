import SwiftUI

extension Options.Content {
    struct Control: View {
        let title: String
        let symbol: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack(spacing: 4) {
                    Image(systemName: symbol)
                        .font(.callout)
                    Text(title)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .allowsHitTesting(false)
            }
        }
    }
}
