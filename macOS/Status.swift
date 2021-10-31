import Foundation
import Combine

struct Status {
    let current: CurrentValueSubject<UUID, Never>
    let flows: CurrentValueSubject<[Item], Never>

    init() {
        let item = Item(flow: .landing)
        flows = .init([item])
        current = .init(item.id)
    }
    
    func addTab() {
        let item = Item(flow: .landing)
        flows.value.append(item)
        current.send(item.id)
    }
    
    func close(id: UUID) {
        guard flows.value.count > 1 else { return }
        
        if current.value == id {
            flows
                .value
                .firstIndex {
                    $0.id == id
                }
                .map {
                    if $0 > 0 {
                        current.value = flows.value[$0 - 1].id
                    } else {
                        current.value = flows.value[$0 + 1].id
                    }
                }
        }
        
        flows
            .value
            .remove {
                $0.id == id
            }
    }
}
