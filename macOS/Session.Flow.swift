import Foundation
import Specs

extension Session {
    enum Flow: Equatable {
        case
        list,
        web(Web),
        message(Web, URL?, String, String)
    }
}
