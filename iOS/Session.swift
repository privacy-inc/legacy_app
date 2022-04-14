import Foundation
import Specs

final class Session: ObservableObject {
    @Published private(set) var current: Current
    @Published var froob = false
    private(set) var items: [Item]
    var dark = false
    
    init() {
        let item = Item(status: .search)
        items = [item]
        current = .item(item.id)
    }
    
    func item(for id: UUID) -> Item {
        items
            .first {
                $0.id == id
            }!
    }
    
    func search(string: String, id: UUID) async {
        do {
            if let id = item!.history {
                try await cloud.search(search, history: id)
                await web()
            } else {
                try await history(id: cloud.search(search))
            }
        } catch {
            flow = .landing
        }
    }
}
