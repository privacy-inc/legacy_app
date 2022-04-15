import Foundation

extension Session {
    enum Flow {
        case
        web,
        search(Bool),
        message(URL?, String, String)
    }
}
