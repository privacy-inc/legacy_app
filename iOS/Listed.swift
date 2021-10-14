import SwiftUI
import Specs

struct Listed: View {
    let item: Website
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            switch item.access {
            case let remote as Access.Remote:
                Remote(title: item.title, access: remote)
                    .allowsHitTesting(false)
            case is Access.Local:
                item(truncate: .head)
            default:
                item(truncate: .tail)
            }
        }
        .font(.caption)
    }
    
    private func item(truncate: Text.TruncationMode) -> some View {
        Text(verbatim: item.access.value)
            .truncationMode(truncate)
            .lineLimit(1)
            .foregroundStyle(.secondary)
            .padding(.vertical, 12)
            .padding(.trailing)
            .allowsHitTesting(false)
    }
}
