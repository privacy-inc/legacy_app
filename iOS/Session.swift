import Foundation
import SwiftUI
import Specs

final class Session: ObservableObject {
    @Published var current: Current
    @Published var froob = false
    private(set) var items: [Item]
    var dark = false
    
    init() {
        let item = Item(flow: .search(false))
        items = [item]
        current = .item(item.id)
    }
    
    func item(for id: UUID) -> Item {
        items
            .first {
                $0.id == id
            }!
    }
    
    func search(id: UUID) {
        withAnimation(.easeInOut(duration: 0.4)) {
            change(flow: .web, of: id)
        }
    }
    
    func change(flow: Flow, of: UUID) {
        items[index(of: of)].flow = flow
        
        if current == .item(of) {
            objectWillChange.send()
        }
    }
    
    @MainActor func search(string: String, id: UUID, focus: Bool) async {
        guard let url = try? await cloud.search(string)
        else {
            if focus {
                search(id: id)
            }
            return
        }
        await open(url: url, id: id)
    }
    
    @MainActor func open(url: URL, id: UUID) async {
        let index = index(of: id)
        
        if items[index].web == nil {
            items[index].web = await  .init(session: self, id: id, settings: cloud.model.settings.configuration, dark: dark)
        }
        
        change(flow: .web, of: id)
        items[index].web!.load(url: url)
    }
    
    private func index(of: UUID) -> Int {
        items
            .firstIndex {
                $0.id == of
            }!
    }
}
