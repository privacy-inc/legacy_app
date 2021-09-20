import Foundation

extension Navigation {
    enum Flow {
        case
        tab(UUID),
        tabs(UUID)
        
        var id: UUID {
            switch self {
            case let .tab(id), let .tabs(id):
                return id
            }
        }
    }
}
