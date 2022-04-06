import Foundation
import Specs

extension Status {
    enum Flow: Equatable {
        case
        list,
        web(Web),
        message(Web, URL?, String, String)
    }
}
