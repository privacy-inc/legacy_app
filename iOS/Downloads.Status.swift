import Foundation

extension Downloads {
    enum Status: Equatable {
        case
        on,
        cancelled(Data)
    }
}
