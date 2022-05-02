import AppKit

extension NSMenu {
    func replace(id: String, download: String, name: String, web: Web) {
        guard let index = items.firstIndex(where: { $0.identifier?.rawValue == id }) else { return }
        let removed = items.remove(at: index)
        
        let here = NSMenuItem(title: NSLocalizedString("Open\(name)", comment: ""), action: #selector(web.here(item:)), keyEquivalent: "")
        here.target = web
        here.representedObject = removed
        
        let stay = NSMenuItem(title: NSLocalizedString("Open\(name) in New Tab", comment: ""), action: #selector(web.tab(stay:)), keyEquivalent: "")
        stay.target = web
        stay.representedObject = removed
        
        let change = NSMenuItem(title: NSLocalizedString("Open\(name) in New Tab and Change", comment: ""), action: #selector(web.tab(change:)), keyEquivalent: "")
        change.target = web
        change.representedObject = removed
        
        let window = NSMenuItem(title: NSLocalizedString("Open\(name) in New Window", comment: ""), action: #selector(web.window(item:)), keyEquivalent: "")
        window.target = web
        window.representedObject = removed
        
        if let download = items.first(where: { $0.identifier?.rawValue == download }) {
            download.target = web
            download.representedObject = removed
            download.action = #selector(web.download(item:))
        }
        
        items
            .insert(contentsOf: [here, stay, change, window, .separator()], at: index)
    }
}
