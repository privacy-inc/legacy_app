import Foundation

extension Session {
    enum Flow: Equatable {
        case
        web,
        message,
        search(Bool)
    }
}
