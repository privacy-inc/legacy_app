import Foundation
import Specs

extension Window.Status {
    enum Flow: Equatable {
        case
        landing,
        web(UInt16),
        error(UInt16, Err)
    }
}
