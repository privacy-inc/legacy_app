import Foundation

extension Landing.Bookmarks {
    final class Remote: Item {
        required init?(coder: NSCoder) { nil }
        init(title: String, favicon: String) {
            let icon = Icon()
            icon.icon(icon: favicon)
            
            super.init(icon: icon)
            self.title.stringValue = title
            self.title.textColor = .secondaryLabelColor
        }
    }
}
