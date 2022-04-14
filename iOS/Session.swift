import Foundation
import Specs

final class Session: ObservableObject {
    @Published private(set) var current: Current
    @Published var froob = false
    private(set) var items: [Item]
    var dark = false
    
    init() {
        let item = Item()
        items = [item]
        current = .item(item.id, .search)
    }
    
    func item(for id: UUID) -> Item {
        items
            .first {
                $0.id == id
            }!
    }
    
    @MainActor func search(string: String, id: UUID) async {
        guard let url = try? await cloud.search(string) else { return }
        await open(url: url, id: id)
    }
    
    @MainActor func open(url: URL, id: UUID) async {
        let index = index(of: id)
        
        if items[index].web == nil {
            items[index].web = await  .init(session: self, id: id, settings: cloud.model.settings.configuration, dark: dark)
        }
        
        current = .item(id, .web)
        items[index].web!.load(url: url)
    }
    
    private func index(of: UUID) -> Int {
        items
            .firstIndex {
                $0.id == of
            }!
    }
}
