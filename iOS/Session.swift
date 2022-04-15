import Foundation
import SwiftUI
import Specs

final class Session: ObservableObject {
    @Published var current: Current
    @Published var froob = false
    var items: [Item]
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
    
    func change(flow: Flow, of: UUID) {
        items[index(of: of)].flow = flow
        
        if current == .item(of) {
            objectWillChange.send()
        }
    }
    
    func thumbnail(id: UUID, image: UIImage) {
        items[index(of: id)].thumbnail = image
    }
    
    @MainActor func search(string: String, id: UUID) async {
        guard let url = try? await cloud.search(string)
        else {
            if item(for: id).web != nil {
                withAnimation(.easeInOut(duration: 0.4)) {
                    change(flow: .web, of: id)
                }
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
