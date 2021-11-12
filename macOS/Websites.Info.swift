import AppKit
import Specs

extension Websites {
    struct Info: CollectionItemInfo {
        let id: Int
        let text: NSAttributedString
        let mode: Mode
        let icon: String?
        
        init(id: Int, history: Specs.History) {
            self.init(id: id,
                      mode: .history(history.id),
                      text: .init(""),
                      icon: history.website.access.icon)
        }
        
        init(id: Int, bookmark: Website) {
            self.init(id: id,
                      mode: .bookmark(bookmark.access),
                      text: .init(""),
                      icon: bookmark.access.icon)
        }
        
        private init(id: Int, mode: Mode, text: AttributedString, icon: String?) {
            self.id = id
            self.mode = mode
            self.text = .init(text)
            self.icon = icon
        }
    }
}
