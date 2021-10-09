import SwiftUI
import Specs

extension Landing.History.Item {
    struct Remote: View {
        let title: String
        let access: Access.Remote
        @State private var publisher: Favicon.Pub?
        
        var body: some View {
            ZStack(alignment: .topLeading) {
                Text("\(Image(uiImage: UIImage.blank)) \(title) \(domain)")
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                if let publisher = publisher {
                    Icon(access: access, publisher: publisher)
                }
            }
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
