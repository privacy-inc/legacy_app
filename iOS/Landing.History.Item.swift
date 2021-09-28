import SwiftUI
import Specs

extension Landing.History {
    struct Item: View {
        let item: History
        
        var body: some View {
            Button {
                
            } label: {
                switch item.website.access {
                case let remote as Access.Remote:
                    Remote(title: item.website.title, access: remote)
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
