import Foundation

extension Navigation {
    enum Flow {
        case
        menu,
        landing(Int),
        web(Int),
        tabs(Int),
        search(Int)
        
        var index: Int {
            switch self {
            case let .landing(index), let .web(index), let .tabs(index), let .search(index):
                return index
            default:
                fatalError()
            }
        }
    }
}
