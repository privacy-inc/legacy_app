/*import AppKit
import Specs

extension Autocomplete {
    struct Info: CollectionItemInfo {
        let id: String
        let first: Bool
        let text: NSAttributedString
        let access: AccessType
        
        init(complete: Complete, first: Bool) {
            id = complete.id
            text = .make(lineBreak: .byTruncatingTail) {
                if !complete.title.isEmpty {
                    $0.append(.make(complete.title, attributes: [
                        .font: NSFont.preferredFont(forTextStyle: .body),
                        .foregroundColor: NSColor.labelColor]))
                    $0.newLine()
                }
                
                if let domain = complete.domain {
                    $0.append(.make(domain, attributes: [
                        .font: NSFont.preferredFont(forTextStyle: .callout),
                        .foregroundColor: NSColor.tertiaryLabelColor]))
                }
                
                $0.append(.make(" " + complete.location.rawValue, attributes: [
                    .font: NSFont.preferredFont(forTextStyle: .callout),
                    .foregroundColor: NSColor.tertiaryLabelColor]))
            }
            access = complete.access
            self.first = first
        }
        
        func hash(into: inout Hasher) {
            into.combine(id)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }
}
*/
