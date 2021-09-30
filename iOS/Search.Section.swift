import SwiftUI

extension Search {
    struct Section<Content>: View where Content : View {
        let title: String
        let content: Content
        
        @inlinable init(_ title: String, @ViewBuilder content: () -> Content) {
            self.title = title
            self.content = content()
        }
        
        var body: some View {
            VStack {
                Text(title)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .font(.footnote)
                    .padding(.leading)
                    .foregroundStyle(.tertiary)
                    .allowsHitTesting(false)
                content
                    .modifier(Card())
                    .padding(.horizontal)
            }
            .padding(.vertical, 8)
        }
    }
}
