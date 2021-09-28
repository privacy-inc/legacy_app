import SwiftUI
import Specs

extension Landing.History.Item {
    struct Remote: View {
        let title: String
        let access: Access.Remote
        @State private var publisher: Favicon.Pub?
        
        var body: some View {
            ZStack(alignment: .topLeading) {
                Text("\(Image(uiImage: Self.blank)) \(title) \(domain)")
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
            Text(verbatim: access.domain)
                .foregroundColor(.secondary)
        }
        
        private static let blank: UIImage = {
            UIGraphicsBeginImageContext(.init(width: 32, height: 32))
            let image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return image
        } ()
    }
}
