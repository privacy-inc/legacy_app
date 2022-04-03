import Foundation
import Specs

extension Status {
    enum Flow: Equatable {
        case
        list,
        web(Web),
        error(Web, Fail)
    }
}
