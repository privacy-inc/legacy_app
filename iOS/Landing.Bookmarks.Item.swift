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
                        item(truncate: .head)
                    default:
                        item(truncate: .tail)
                    }
                }
                .frame(height: 70)
                .frame(maxWidth: 120)
                .allowsHitTesting(false)
            }
        }
        
        private func item(truncate: Text.TruncationMode) -> some View {
            Text(verbatim: item.access.value)
                .truncationMode(truncate)
                .font(.caption2.weight(.light))
                .lineLimit(3)
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
                .padding(.horizontal)
                .padding(.top, 5)
        }
    }
}
