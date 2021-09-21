import SwiftUI

extension Landing {
    struct Card: ViewModifier {
        func body(content: Content) -> some View {
            content
                .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.05), radius: 10))
        }
    }
}
