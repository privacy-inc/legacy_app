import SwiftUI
import Specs

extension Landing.History {
    struct Item: View {
        let item: Specs.History
        let select: (UInt16) -> Void
        
        var body: some View {
            Button {
                select(item.id)
            } label: {
                switch item.website.access {
                case let remote as Access.Remote:
                    Remote(title: item.website.title, access: remote)
                        .allowsHitTesting(false)
                case let local as Access.Local:
                    item(title: local.file)
                case let deeplink as Access.Deeplink:
                    item(title: deeplink.scheme)
                case let embed as Access.Embed:
                    item(title: embed.prefix)
                default:
                    EmptyView()
                }
            }
            .font(.caption)
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .modifier(Card())
        }
        
        private func item(title: String) -> some View {
            Text(verbatim: title)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .allowsHitTesting(false)
        }
    }
}
