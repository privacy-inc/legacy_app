import SwiftUI
import Specs

extension Listed {
    struct Remote: View {
        let title: String
        let access: Access.Remote
        @State private var publisher: Favicon.Pub?
        
        var body: some View {
            HStack {
                if let publisher = publisher {
                    Icon(access: access, publisher: publisher)
                }
                Text("\(title) \(domain)")
                    .lineLimit(2)
            }
            .padding(.vertical, 8)
            .task {
                publisher = await favicon.publisher(for: access)
            }
        }
        
        private var domain: Text {
            Text(verbatim: access.domain.minimal)
                .foregroundColor(.secondary)
        }
    }
}
