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
                        .shadow(color: .init(white: 0, opacity: 0.1), radius: 2)
                    HStack {
                        Text(title)
                            .lineLimit(1)
                            .font(.callout)
                        Spacer()
                        Image(systemName: symbol)
                            .symbolRenderingMode(.hierarchical)
                            .frame(width: 22)
                            .font(.body)
                    }
                    .padding(.horizontal)
                    .foregroundStyle(.primary)
                }
                .frame(height: 50)
                .allowsHitTesting(false)
            }
            .padding(.horizontal)
        }
    }
}
