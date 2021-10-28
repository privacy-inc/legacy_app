import Foundation
import Specs

extension Landing.Bookmarks {
    final class Remote: Item {
        required init?(coder: NSCoder) { nil }
        init(bookmark: Website) {
            let icon = Icon()
            icon.icon(icon: bookmark.access.icon)
            
            super.init(icon: icon)
            title.stringValue = bookmark.title
            title.textColor = .secondaryLabelColor
        }
    }
}
