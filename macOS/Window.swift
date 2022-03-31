import AppKit

final class Window: NSWindow, NSWindowDelegate {
    let status: Status
    
    @discardableResult init(status: Status) {
        self.status = status
        super.init(contentRect: .init(x: 0,
                                      y: 0,
                                      width: NSScreen.main!.frame.width * 0.5,
                                      height: NSScreen.main!.frame.height),
                   styleMask: [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView],
                   backing: .buffered,
                   defer: false)
        minSize = .init(width: 500, height: 200)
        toolbar = .init()
        isReleasedWhenClosed = false
        setFrameAutosaveName("Window")
        tabbingMode = .disallowed
        titlebarAppearsTransparent = true
        delegate = self
        
        let top = NSTitlebarAccessoryViewController()
        top.view = Bar(status: status)
        top.layoutAttribute = .top
        addTitlebarAccessoryViewController(top)
        
        let bottom = NSTitlebarAccessoryViewController()
//        bottom.view = Subbar(status: status)
        bottom.layoutAttribute = .bottom
//        addTitlebarAccessoryViewController(bottom)
        #warning("use for downloads")

        let findbar = Findbar()
        addTitlebarAccessoryViewController(findbar)
        
        contentView = Content(status: status, findbar: findbar)
        makeKeyAndOrderFront(nil)
    }
    
    override func close() {
        status
            .items
            .value
            .forEach {
                $0.clear()
            }
        super.close()
    }
    
    func windowDidEnterFullScreen(_: Notification) {
        titlebarAccessoryViewControllers
            .compactMap {
                $0.view as? NSVisualEffectView
            }
            .forEach {
                $0.material = .sheet
            }
    }
    
    func windowDidExitFullScreen(_: Notification) {
        titlebarAccessoryViewControllers
            .compactMap {
                $0.view as? NSVisualEffectView
            }
            .forEach {
                $0.material = .menu
            }
    }
    
    @objc func triggerSearch() {
        status.search.send()
    }
    
    @objc func triggerCloseTab() {
        guard status.items.value.count > 1 else {
            close()
            return
        }
        status.close(id: status.current.value)
    }
    
    @objc func triggerNextTab() {
        status.nextTab()
    }
    
    @objc func triggerPreviousTab() {
        status.previousTab()
    }
}
