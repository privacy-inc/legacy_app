import AppKit

extension NSApplication {
    var dark: Bool {
        effectiveAppearance.name != .aqua
    }
    
    var windowsOpen: Int {
        windows
            .filter {
                $0 is Window
            }
            .count
    }
    
    var tabsOpen: Int {
        windows
            .compactMap {
                $0 as? Window
            }
            .map {
                $0
                    .status
                    .items
                    .value
                    .count
            }
            .reduce(0, +)
    }
    
    var activeWindow: Window? {
        keyWindow as? Window ?? anyWindow()
    }
    
    func open(url: URL) {
        if let window = activeWindow {
            Task {
                await window.status.url(url: url)
                window.makeKeyAndOrderFront(nil)
            }
        } else {
            newWindow(url: url)
        }
    }
    
    func silent(url: URL) {
        if let window = activeWindow {
            Task {
                await window.status.silent(url: url)
            }
        }
    }
    
    func newWindow(url: URL) {
        Task {
            let status = Status()
            await status.url(url: url)
            Window.new(status: status)
        }
    }
    
    func closeAllWindows() {
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
    
    
    
    func anyWindow<T>() -> T? {
        windows
            .compactMap {
                $0 as? T
            }
            .first
    }
    
    @objc func show() {
        activeWindow?
            .orderFrontRegardless()
    }
    
    @objc func closeAll() {
        windows
            .forEach {
                $0.close()
            }
    }
    
    @objc func showPreferencesWindow(_ sender: Any?) {
//        (anyWindow() ?? Settings())
//            .makeKeyAndOrderFront(nil)
    }
}
