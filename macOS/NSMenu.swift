import AppKit

extension NSMenu {
    @discardableResult func discard(where transform: (NSMenuItem) -> Bool) -> Self {
        items
            .removeAll(where: transform)
        return self
    }
    
    func mutate(id: String, transform: (NSMenuItem) -> Void) {
        items
            .first {
                $0.identifier?.rawValue == id
            }
            .map(transform)
    }
    
    @discardableResult func remove(id: String) -> NSMenuItem? {
        items
            .remove {
                $0.identifier?.rawValue == id
            }
    }
}
