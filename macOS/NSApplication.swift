import AppKit
import Specs

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
            let id = window.status.current.value
            Task {
                await window.status.open(url: url, id: id)
                window.makeKeyAndOrderFront(nil)
            }
        } else {
            newWindow(url: url)
        }
    }
    
    func silent(url: URL) {
        if let window = activeWindow {
            let id = window.status.current.value
//            Task {
//                await window.status.silent(url: url)
//            }
        }
    }
    
    func newWindow(url: URL) {
        Task {
            let status = Status()
            await status.open(url: url, id: status.current.value)
            Window(status: status)
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
    
    @objc func showTrackers() {
//        (anyWindow() ?? Trackers())
//            .makeKeyAndOrderFront(nil)
    }
    
    @objc func showActivity() {
//        (anyWindow() ?? Activity())
//            .makeKeyAndOrderFront(nil)
    }
    
    @objc func showHistory() {
//        (anyWindow() ?? History())
//            .makeKeyAndOrderFront(nil)
    }
    
    @objc func showBookmarks() {
//        (anyWindow() ?? Bookmarks())
//            .makeKeyAndOrderFront(nil)
    }
    
    @objc func showPreferencesWindow(_ sender: Any?) {
        (anyWindow() ?? Preferences())
            .makeKeyAndOrderFront(nil)
    }
    
    @objc func showPrivacyPlus() {
        (NSApp.anyWindow() ?? Plus())
            .makeKeyAndOrderFront(nil)
    }
}
