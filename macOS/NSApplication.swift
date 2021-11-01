import AppKit

extension NSApplication {
    var dark: Bool {
        effectiveAppearance.name != .aqua
    }
    
//    func newTabWith(url: URL) {
//        guard let window = activeWindow else {
//            newWindowWith(url: url)
//            return
//        }
//        window.session.open.send((url: url, change: true))
//    }
    
//    func newWindowWith(url: URL) {
//        cloud
//            .navigate(url) { browse, _ in
//                Window(tab:
//                        .init(browse: browse))
//                    .makeKeyAndOrderFront(nil)
//            }
//    }
    
    func closeAll() {
        windows
            .compactMap {
                $0 as? Window
            }
            .forEach {
                $0.close()
            }
    }
    
//    func activity() {
//        (anyWindow() ?? Activity())
//            .makeKeyAndOrderFront(nil)
//    }
//
//    func trackers() {
//        (anyWindow() ?? Trackers())
//            .makeKeyAndOrderFront(nil)
//    }
//
//    func froob() {
//        (anyWindow() ?? Info.Froob())
//            .makeKeyAndOrderFront(nil)
//    }
//
//    func why() {
//        (anyWindow() ?? Info.Why())
//            .makeKeyAndOrderFront(nil)
//    }
//
//    func alternatives() {
//        (anyWindow() ?? Info.Alternatives())
//            .makeKeyAndOrderFront(nil)
//    }
//
//    func store() {
//        (anyWindow() ?? Store())
//            .makeKeyAndOrderFront(nil)
//    }
    
//    @objc func newTab() {
//        guard let window = activeWindow else {
//            newWindow()
//            return
//        }
//        window.plus()
//    }
//
    
    @objc func showPreferencesWindow(_ sender: Any?) {
//        (anyWindow() ?? Settings())
//            .makeKeyAndOrderFront(nil)
    }
    
    func anyWindow<T>() -> T? {
        windows
            .compactMap {
                $0 as? T
            }
            .first
    }
    
    private var activeWindow: Window? {
        keyWindow as? Window ?? anyWindow()
    }
}
