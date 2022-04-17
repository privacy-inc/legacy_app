import SwiftUI

extension Detail {
    struct Action: View {
        let title: String
        let icon: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .regular))
                        .symbolRenderingMode(.hierarchical)
                    Text(title)
                        .font(.footnote)
                }
                .frame(width: 100)
                .contentShape(Rectangle())
            }
        }
    }
}
