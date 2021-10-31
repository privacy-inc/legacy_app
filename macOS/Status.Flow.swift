import Foundation
import Specs

extension Status {
    enum Flow: Equatable {
        case
        landing,
        web(Web),
        error(Web, Err)
    }
}
