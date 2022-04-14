import Foundation

extension Session {
    enum Flow {
        case
        search,
        web,
        message(URL?, String, String)
    }
}
