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
                      website: history.website)
        }
        
        init(id: Int, bookmark: Website) {
            self.init(id: id,
                      mode: .bookmark(bookmark.access),
                      website: bookmark)
        }
        
        private init(id: Int, mode: Mode, website: Website) {
            self.id = id
            self.mode = mode
            icon = website.access.icon
            
            let string: AttributedString
            
            switch website.access {
            case let remote as Access.Remote:
                string = .init(website.title, attributes: .init([
                    .font: NSFont.preferredFont(forTextStyle: .title3),
                    .foregroundColor: NSColor.labelColor]))
                + .newLine
                + .init(remote.domain.minimal, attributes: .init([
                    .font: NSFont.preferredFont(forTextStyle: .body),
                    .foregroundColor: NSColor.secondaryLabelColor]))
            default:
                string = .init(website.access.value, attributes: .init([
                    .font: NSFont.preferredFont(forTextStyle: .body),
                    .foregroundColor: NSColor.secondaryLabelColor]))
            }
            
            text = .init(string.with(truncating: .byTruncatingTail))
        }
    }
}
