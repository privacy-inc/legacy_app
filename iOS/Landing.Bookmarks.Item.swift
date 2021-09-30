import SwiftUI
import Specs

extension Landing.Bookmarks {
    struct Item: View {
        let item: Website
        let select: (URL) -> Void
        
        var body: some View {
            Button {
                item
                    .access
                    .url
                    .map(select)
            } label: {
                VStack {
                    switch item.access {
                    case let remote as Access.Remote:
                        Remote(title: item.title, access: remote)
                    case let local as Access.Local:
                        Circle()
                    case let deeplink as Access.Deeplink:
                        Circle()
                    case let embed as Access.Embed:
                        Circle()
                    default:
                        EmptyView()
                    }
                }
                .frame(height: 100)
                .allowsHitTesting(false)
            }
        }
    }
}
