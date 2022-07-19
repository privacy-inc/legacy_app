import AppKit
import Specs

extension NSApplication {
    var activeWindow: Window? {
        keyWindow as? Window ?? anyWindow()
    }
    
    func open(url: URL, change: Bool) {
        if let window = activeWindow {
            let id = window.session.current.value
            Task {
                if window.session.flow(of: id) == .list {
                    await window.session.open(url: url, id: id)
                } else {
                    await window.session.open(url: url, change: change)
                }
                
                window.makeKeyAndOrderFront(nil)
            }
        } else {
            window(url: url)
        }
    }
    
    func window(url: URL) {
        Task {
            let session = Session()
            await session.open(url: url, id: session.current.value)
            window(session: session)
        }
    }
    
    func anyWindow<T>() -> T? {
        windows
            .compactMap {
                $0 as? T
            }
            .first
    }
    
    func window(session: Session) {
        Window(session: session).makeKeyAndOrderFront(nil)
    }
    
    @objc func newWindow() {
        window(session: .init())
    }
    
    @objc func show() {
        NSApp.activate(ignoringOtherApps: true)
        activeWindow?
            .orderFrontRegardless()
    }
    
    @objc func closeAll() {
        windows
            .filter {
                $0 != (NSApp.mainMenu as! Menu).shortcut.button?.window
            }
            .forEach {
                $0.close()
            }
    }
}
