import Foundation

extension Status {
    struct Item: Equatable {
        var flow: Flow
        let id = UUID()
        
        func clear() {
            switch flow {
            case let .web(web), let .error(web, _):
                web.clear()
            default:
                break
            }
        }
    }
}
