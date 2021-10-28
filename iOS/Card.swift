import SwiftUI

struct Card: ViewModifier {
    @Environment(\.colorScheme) private var scheme
    
    func body(content: Content) -> some View {
        content
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(.tertiarySystemBackground))
                            .shadow(color: .black.opacity(scheme == .dark ? 1 : 0.1), radius: 4))
    }
}
