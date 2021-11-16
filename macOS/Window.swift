import AppKit

final class Window: NSWindow, NSWindowDelegate {
    class func new() {
        new(status: .init())
    }
    
    class func new(status: Status) {
        Window(status: status).makeKeyAndOrderFront(nil)
    }
    
    let status: Status
    private(set) weak var finder: Finder!
    
    private init(status: Status) {
        self.status = status
        
        super.init(contentRect: .init(x: 0,
                                      y: 0,
                                      width: NSScreen.main!.frame.width * 0.5,
                                      height: NSScreen.main!.frame.height),
                   styleMask: [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView],
                   backing: .buffered,
                   defer: false)
        minSize = .init(width: 600, height: 300)
        toolbar = .init()
        isReleasedWhenClosed = false
        setFrameAutosaveName("Window")
        tabbingMode = .disallowed
        titlebarAppearsTransparent = true
        
        let finder = Finder()
        contentView = Content(status: status, finder: finder)
        delegate = self
        
        let top = NSTitlebarAccessoryViewController()
        top.view = Bar(status: status)
        top.layoutAttribute = .top
        addTitlebarAccessoryViewController(top)

        finder.layoutAttribute = .bottom
        finder.reset()
        self.finder = finder
        addTitlebarAccessoryViewController(finder)
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
