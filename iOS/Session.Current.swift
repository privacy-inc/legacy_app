import Foundation

extension Session {
    enum Current {
        case
        tabs,
        settings,
        item(UUID)
    }
}
