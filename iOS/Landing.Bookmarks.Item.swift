import SwiftUI
import Specs

extension Landing.Bookmarks {
    struct Item: View {
        let item: Website
        let select: (AccessType) -> Void
        
        var body: some View {
            Button {
                select(item.access)
            } label: {
                VStack {
                    switch item.access {
                    case let remote as Access.Remote:
                        Remote(title: item.title, access: remote)
                    case is Access.Local:
                        Other(title: item.access.value, truncate: .head)
                    default:
                        Other(title: item.access.value, truncate: .tail)
                    }
                }
                .frame(height: 105)
                .frame(maxWidth: 120)
                .allowsHitTesting(false)
            }
        }
    }
}
