import SwiftUI
import Specs

extension Landing.Bookmarks.Item {
    struct Remote: View {
        let title: String
        let access: Access.Remote
        
        var body: some View {
            Icon(icon: access.icon)
                .padding(15)
                .modifier(Card())
            Text(verbatim: title)
                .font(.caption2)
                .lineLimit(2)
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .top)
                .padding(.horizontal)
        }
    }
}
