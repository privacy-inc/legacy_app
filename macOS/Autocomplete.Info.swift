import Foundation
import Specs

extension Autocomplete {
    struct Info: CollectionItemInfo {
        let id: String
        let first: Bool
        let string: NSAttributedString
        let access: AccessType
        
        init(complete: Complete, first: Bool) {
            id = complete.id
            string = .init()
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
