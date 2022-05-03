import AppKit

extension NSMenu {
    func replace(id: String, download: String, name: String, web: Web) {
        guard let index = items.firstIndex(where: { $0.identifier?.rawValue == id }) else { return }
        let removed = items.remove(at: index)
        
        let here = NSMenuItem(title: NSLocalizedString("Open\(name)", comment: ""), action: #selector(web.forward(item:)), keyEquivalent: "")
        here.target = web
        here.representedObject = removed
        here.tag = Destination.here.rawValue
        
        let stay = NSMenuItem(title: NSLocalizedString("Open\(name) in New Tab", comment: ""), action: #selector(web.forward(item:)), keyEquivalent: "")
        stay.target = web
        stay.representedObject = removed
        stay.tag = Destination.tabStay.rawValue
        
        let change = NSMenuItem(title: NSLocalizedString("Open\(name) in New Tab and Change", comment: ""), action: #selector(web.forward(item:)), keyEquivalent: "")
        change.target = web
        change.representedObject = removed
        change.tag = Destination.tabChange.rawValue
        
        let window = NSMenuItem(title: NSLocalizedString("Open\(name) in New Window", comment: ""), action: #selector(web.forward(item:)), keyEquivalent: "")
        window.target = web
        window.representedObject = removed
        window.tag = Destination.window.rawValue
        
        if let download = items.first(where: { $0.identifier?.rawValue == download }) {
            download.target = web
            download.representedObject = removed
            download.action = #selector(web.forward(item:))
            download.tag = Destination.download.rawValue
        }
        
        items
            .insert(contentsOf: [here, stay, change, window, .separator()], at: index)
    }
}
