import SwiftUI

extension Detail {
    struct Action: View {
        let title: String
        let icon: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack {
                    Text(title)
                        .font(.callout)
                    Spacer()
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .regular))
                        .symbolRenderingMode(.hierarchical)
                        .frame(width: 20)
                }
                .padding(.vertical, 13)
            }
        }
    }
}
