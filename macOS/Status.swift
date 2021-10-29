import Foundation
import Combine

struct Status {
    let current = PassthroughSubject<UUID, Never>()
    let flows = CurrentValueSubject<[UUID : Flow], Never>([:])

    func addTab() {
        let id = UUID()
        flows.value[id] = .landing
        current.send(id)
    }
}
