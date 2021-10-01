import SwiftUI

struct Action: View {
    let title: String
    let symbol: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.footnote)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: symbol)
                    .font(.body)
                    .frame(width: 20)
            }
            .allowsHitTesting(false)
        }
    }
}
