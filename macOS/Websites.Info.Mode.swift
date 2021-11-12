import Foundation
import Specs

extension Websites.Info {
    enum Mode: Hashable {
        case
        history(UInt16),
        bookmark(AccessType)
        
        func hash(into: inout Hasher) {
            into.combine("\(self)")
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            switch lhs {
            case let .history(idLeft):
                switch rhs {
                case let .history(idRight):
                    return idLeft == idRight
                case .bookmark:
                    return false
                }
            case let .bookmark(accessLeft):
                switch rhs {
                case .history:
                    return false
                case let .bookmark(accessRight):
                    return accessLeft.value == accessRight.value
                }
            }
        }
    }
}
