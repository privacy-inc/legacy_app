import Foundation

extension Browser {
    final class Status: ObservableObject {
        @Published var small = true
        @Published var reader = false
        @Published var find = false
    }
}
