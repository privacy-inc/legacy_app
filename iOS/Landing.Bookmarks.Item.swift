import SwiftUI
import Specs

extension Landing.Bookmarks {
    struct Item: View {
        let item: Website
        
        var body: some View {
            Button {
                
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
