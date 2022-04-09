import AppKit

extension Menu {
    final class Share: NSMenuItem {
        private let url: URL
        
        required init(coder: NSCoder) { fatalError() }
        init(url: URL, icon: Bool) {
            self.url = url
            
            super.init(title: "Share", action: nil, keyEquivalent: "")
            submenu = .init(title: "Share")
            submenu!.items = [
                .child(url.absoluteString.capped),
                .separator()]
                    + NSSharingService
                        .sharingServices(forItems: [url])
                        .map { service in
                            .child(service.menuItemTitle, #selector(share)) {
                                $0.target = self
                                $0.image = service.image
                                $0.representedObject = service
                            }
                        }
            if icon {
                image = .init(systemSymbolName: "square.and.arrow.up", accessibilityDescription: nil)
            }
        }
        
        @objc private func share(_ item: NSMenuItem) {
            guard let service = item.representedObject as? NSSharingService else { return }
            service.perform(withItems: [url])
        }
    }
}
