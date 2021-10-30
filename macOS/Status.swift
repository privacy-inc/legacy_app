import Foundation
import Combine

final class Status {
    let current = PassthroughSubject<UUID, Never>()
    let flows = CurrentValueSubject<[Item], Never>([])

    func addTab() {
        let item = Item(flow: .landing)
        flows.value.append(item)
        current.send(item.id)
    }
    
    func close(id: UUID) {
        flows
            .value
            .remove {
                $0.id == id
            }
    }
}
