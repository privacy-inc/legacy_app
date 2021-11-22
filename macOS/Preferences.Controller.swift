import AppKit

extension Preferences {
    final class Controller: NSTabViewController {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(nibName: nil, bundle: nil)
            tabStyle = .toolbar
            tabViewItems = [
                General(),
                Browser(),
                Navigation(),
                Features(),
                Javascript(),
                Location()
            ]
        }
        
        override func tabView(_: NSTabView, willSelect: NSTabViewItem?) {
            guard
                let window = view.window,
                let tab = willSelect as? Tab
            else { return }
            let frame = window.frameRect(forContentRect: .init(origin: .zero, size: tab.size))
            window.title = tab.label
            window.setFrame(.init(origin:
                                        .init(x: window.frame.origin.x - ((frame.size.width - window.frame.size.width) / 2),
                                              y: window.frame.origin.y + (window.frame.size.height - frame.size.height)),
                                  size: frame.size), display: false, animate: true)
        }
    }
}
