import SwiftUI

extension Landing {
    struct Card: ViewModifier {
        let action: () -> Void
        
        func body(content: Content) -> some View {
            Button(action: action) {
                content
                    .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.05), radius: 10))
            }
        }
    }
}
