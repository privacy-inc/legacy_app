import Foundation

extension Session {
    struct Item: Equatable {
        let id: UUID
        let flow: Flow
        
        init(id: UUID = .init(), flow: Flow) {
            self.id = id
            self.flow = flow
        }
        
        func with(flow: Flow) -> Self {
            .init(id: id, flow: flow)
        }
    }
}
