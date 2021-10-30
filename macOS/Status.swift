import Foundation
import Combine

struct Status {
    let current = PassthroughSubject<UUID, Never>()
    let flows = CurrentValueSubject<[Item], Never>([])

    func addTab() {
        let item = Item(flow: .landing)
        flows.value.append(item)
        current.send(item.id)
    }
}
