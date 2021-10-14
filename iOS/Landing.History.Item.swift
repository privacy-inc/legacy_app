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
                case is Access.Local:
                    item(truncate: .head)
                default:
                    item(truncate: .tail)
                }
            }
            .font(.caption)
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .modifier(Card())
        }
        
        private func item(truncate: Text.TruncationMode) -> some View {
            Text(verbatim: item.website.access.value)
                .truncationMode(truncate)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .allowsHitTesting(false)
        }
    }
}
