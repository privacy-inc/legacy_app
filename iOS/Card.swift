import SwiftUI

struct Card: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(.systemBackground))
                            .shadow(color: .primary.opacity(0.05), radius: 5))
    }
}
