import Foundation

extension Status {
    struct Item: Equatable {
        let id: UUID
        let flow: Flow
        
        init(flow: Flow) {
            self.flow = flow
            id = .init()
        }
        
        private init(id: UUID, flow: Flow) {
            self.id = id
            self.flow = flow
        }
        
        func with(flow: Flow) -> Self {
            .init(id: id, flow: flow)
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
