import SwiftUI
import Specs

extension Landing.Bookmarks.Item {
    struct Remote: View {
        let title: String
        let access: Access.Remote
        @State private var publisher: Favicon.Pub?
        
        var body: some View {
            if let publisher = publisher {
                Icon(access: access, publisher: publisher)
            }
            Text(verbatim: title)
                .font(.caption2)
                .lineLimit(2)
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .top)
                .padding(.horizontal)
                .task {
                    publisher = await favicon.publisher(for: access)
                }
        }
    }
}
