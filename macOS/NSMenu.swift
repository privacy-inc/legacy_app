import AppKit

extension NSMenu {
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
