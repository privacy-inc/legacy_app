import Foundation
import Specs

final class Session: ObservableObject {
    @Published private(set) var current: Current
    @Published private(set) var items: [Item]
    @Published var froob = false
    var dark = false
    
    init() {
        let item = Item(status: .search)
        items = [item]
        current = .item(item.id)
    }
}
