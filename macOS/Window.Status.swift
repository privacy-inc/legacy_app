import Foundation
import Combine

extension Window {
    struct Status {
        let current = PassthroughSubject<UUID, Never>()
        let flows = CurrentValueSubject<[UUID : Flow], Never>([:])
    }
}
