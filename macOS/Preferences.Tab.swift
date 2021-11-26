import AppKit

extension Preferences {
    class Tab: NSTabViewItem {
        let size: CGSize
        
        required init?(coder: NSCoder) { nil }
        init(size: CGSize, title: String, symbol: String) {
            self.size = size
            
            super.init(identifier: "")
            label = title
            image = .init(systemSymbolName: symbol, accessibilityDescription: nil)
            
            let content = NSVisualEffectView()
            content.state = .active
            content.material = .sidebar
            viewController = .init()
            viewController!.view = content
        }
    }
}
