import SwiftUI

extension Landing.Bookmarks.Item {
    struct Other: View {
        let title: String
        let truncate: Text.TruncationMode
        
        var body: some View {
            Image(systemName: "globe")
                .font(.title.weight(.light))
                .foregroundStyle(.tertiary)
                .padding(15)
                .modifier(Card())
            Text(verbatim: title)
                .truncationMode(truncate)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .top)
                .padding(.horizontal)
        }
    }
}
