import SwiftUI

extension Options.Content {
    struct Control: View {
        let title: String
        let symbol: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.systemBackground))
                    HStack {
                        Text(title)
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: symbol)
                            .symbolRenderingMode(.hierarchical)
                    }
                    .font(.callout)
                    .padding(.horizontal)
                    .padding(.vertical, 14)
                    .foregroundStyle(.secondary)
                }
                .fixedSize(horizontal: false, vertical: true)
                .allowsHitTesting(false)
                .padding(.vertical, 6)
            }
        }
    }
}
