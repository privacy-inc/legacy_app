import Foundation

extension Session {
    enum Current: Equatable {
        case
        tabs,
        settings,
        item(Int)
    }
}
