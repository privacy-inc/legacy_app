import SwiftUI

extension Options.Content {
    struct Control: View {
        let title: String
        let symbol: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemBackground))
                    HStack {
                        Text(title)
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: symbol)
                            .symbolRenderingMode(.hierarchical)
                    }
                    .font(.callout)
                    .padding()
                    .foregroundStyle(.primary)
                }
                .fixedSize(horizontal: false, vertical: true)
                .allowsHitTesting(false)
            }
        }
    }
}
