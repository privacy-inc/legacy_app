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
            text = .make {
                switch website.access {
                case let remote as Access.Remote:
                    if !website.title.isEmpty {
                        $0.append(.make(website.title, attributes: [
                            .font: NSFont.preferredFont(forTextStyle: .body),
                            .foregroundColor: NSColor.labelColor],
                                        lineBreak: .byTruncatingTail))
                        $0.newLine()
                    }
                    $0.append(.make(remote.domain.minimal, attributes: [
                        .font: NSFont.preferredFont(forTextStyle: .footnote),
                        .foregroundColor: NSColor.secondaryLabelColor],
                                    lineBreak: .byTruncatingTail))
                default:
                    $0.append(.make(website.access.value, attributes: [
                        .font: NSFont.preferredFont(forTextStyle: .footnote),
                        .foregroundColor: NSColor.secondaryLabelColor],
                                    lineBreak: .byTruncatingTail))
                }
            }
        }
    }
}
