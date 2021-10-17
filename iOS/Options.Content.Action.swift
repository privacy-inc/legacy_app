import SwiftUI

extension Options.Content {
    struct Action: View {
        let symbol: String
        let active: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Image(systemName: symbol)
                    .font(.callout.bold())
                    .frame(width: 24, height: 18)
                    .foregroundStyle(active ? .primary : .quaternary)
                    .allowsHitTesting(false)
            }
            .allowsHitTesting(active)
            .buttonStyle(.bordered)
        }
    }
}
