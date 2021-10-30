import Foundation

extension Status {
    struct Item: Equatable {
        let flow: Flow
        let id = UUID()
    }
}
