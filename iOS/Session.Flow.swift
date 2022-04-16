import Foundation

extension Session {
    enum Flow: Equatable {
        case
        web,
        search(Bool),
        message(Info)
    }
}
