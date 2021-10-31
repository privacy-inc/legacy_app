import Foundation

extension Status {
    struct Item: Equatable {
        var flow: Flow
        let id = UUID()
    }
}
