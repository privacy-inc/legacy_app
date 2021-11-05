import Foundation

extension Status {
    struct Item: Equatable {
        var flow: Flow
        let id: UUID
        
        init(flow: Flow) {
            self.flow = flow
            id = .init()
        }
        
        init(id: UUID, web: Web) {
            self.flow = .web(web)
            self.id = id
        }
        
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
