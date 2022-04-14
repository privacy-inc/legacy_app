import Foundation

extension Session.Item {
    enum Status {
        case
        search,
        web,
        message(URL?, String, String)
    }
}
