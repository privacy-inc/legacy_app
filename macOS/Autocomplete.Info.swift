import AppKit
import Specs

extension Autocomplete {
    struct Info: CollectionItemInfo {
        let id: String
        let first: Bool
        let text: NSAttributedString
        let access: AccessType
        
        init(complete: Complete, first: Bool) {
            var string = AttributedString(complete.title, attributes: .init([
                .font: NSFont.preferredFont(forTextStyle: .body),
                .foregroundColor: NSColor.labelColor]))
                .with(truncating: .byTruncatingTail)
            
            if !complete.title.isEmpty {
                string += .newLine
            }
            
            if let domain = complete.domain {
                string += .init(domain, attributes: .init([
                    .font: NSFont.preferredFont(forTextStyle: .callout),
                    .foregroundColor: NSColor.secondaryLabelColor]))
            }
            
            string += .init(" " + complete.location.rawValue, attributes: .init([
                .font: NSFont.preferredFont(forTextStyle: .callout),
                .foregroundColor: NSColor.tertiaryLabelColor]))
            
            id = complete.id
            text = .init(string.with(truncating: .byTruncatingTail))
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
