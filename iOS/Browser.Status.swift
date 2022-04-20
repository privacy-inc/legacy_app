import Foundation
import Combine

extension Browser {
    final class Status: ObservableObject {
        @Published var small = true
        @Published var reader = false
        @Published var find = false
        let features = PassthroughSubject<Void, Never>()
        let share = PassthroughSubject<Void, Never>()
    }
}
