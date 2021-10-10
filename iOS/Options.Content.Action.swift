import SwiftUI

extension Options.Content {
    struct Action: View {
        let symbol: String
        let active: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Image(systemName: symbol)
                    .font(.callout.weight(.medium))
                    .frame(width: 64, height: 40)
                    .foregroundStyle(active ? .primary : .quaternary)
                    .allowsHitTesting(false)
            }
            .allowsHitTesting(active)
        }
    }
}
