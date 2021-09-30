import SwiftUI
import Specs

extension Landing.History {
    struct Item: View {
        let item: History
        let select: (Int) -> Void
        
        var body: some View {
            Button {
                select(item.id)
            } label: {
                switch item.website.access {
                case let remote as Access.Remote:
                    Remote(title: item.website.title, access: remote)
                        .allowsHitTesting(false)
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
            .font(.caption)
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .modifier(Card())
        }
    }
}
