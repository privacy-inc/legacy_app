import AppKit
import Specs

extension NSApplication {
    var dark: Bool {
        effectiveAppearance.name != .aqua
    }
    
    var activeWindow: Window? {
        keyWindow as? Window ?? anyWindow()
    }
    
    func open(url: URL) {
        if let window = activeWindow {
            let id = window.status.current.value
            Task {
                if window.status.flow(of: id) == .list {
                    await window.status.open(url: url, id: id)
                } else {
                    await window.status.open(url: url, change: true)
                }
                
                window.makeKeyAndOrderFront(nil)
            }
        } else {
            window(url: url)
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
    
    func window(url: URL) {
        Task {
            let status = Status()
            await status.open(url: url, id: status.current.value)
            window(status: status)
        }
    }
    
    func anyWindow<T>() -> T? {
        windows
            .compactMap {
                $0 as? T
            }
            .first
    }
    
    func window(status: Status) {
        Window(status: status).makeKeyAndOrderFront(nil)
    }
    
    @objc func newWindow() {
        window(status: .init())
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
}
