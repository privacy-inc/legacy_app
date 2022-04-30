import SwiftUI

struct Card: ViewModifier {
    let dark: Bool
    
    func body(content: Content) -> some View {
        content
            .fixedSize(horizontal: false, vertical: true)
            .background(Color(.tertiarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: .black.opacity(dark ? 1 : 0.1), radius: 3)
    }
}
