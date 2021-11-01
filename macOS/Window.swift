import AppKit

final class Window: NSWindow {
    class func new() {
        new(status: .init())
    }
    
    class func new(status: Status) {
        let window = Window(status: status)
        window.makeKeyAndOrderFront(nil)
    }
    
    private init(status: Status) {
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
        contentView = Content(status: status)

        let accessory = NSTitlebarAccessoryViewController()
        accessory.view = Bar(status: status)
        accessory.layoutAttribute = .top
        addTitlebarAccessoryViewController(accessory)
    }/*
    
    override func close() {
        session
            .tab
            .items
            .value
            .ids
            .forEach(session.close.send)
        super.close()
    }
    
    override func closeTab() {
        guard session.tab.items.value.count > 1 else {
            close()
            return
        }
        session
            .close
            .send(session
                    .current
                    .value)
    }
    
    @objc func plus() {
        session
            .plus
            .send()
    }
    
    @objc func stop() {
        session.stop.send(session.current.value)
    }

    @objc func reload() {
        session.reload.send(session.current.value)
    }

    @objc func actualSize() {
        session.actualSize.send(session.current.value)
    }

    @objc func zoomIn() {
        session.zoomIn.send(session.current.value)
    }

    @objc func zoomOut() {
        session.zoomOut.send(session.current.value)
    }
    
    @objc func tryAgain() {
        switch session
            .tab
            .items
            .value[state: session.current.value] {
        case let .error(browse, error):
            cloud
                .browse(error.url, browse: browse) { [weak self] in
                    guard let id = self?.session.current.value else { return }
                    self?
                        .session
                        .tab
                        .browse(id, browse)
                    self?
                        .session
                        .load
                        .send((id: id, access: $1))
                }
        default: break
        }
    }
    
    @objc func location() {
        session
            .search
            .send(session
                    .current
                    .value)
    }
    
    @objc func nextTab() {
        session
            .tab
            .items
            .value
            .ids
            .firstIndex(of: session.current.value)
            .map {
                session
                    .current
                    .send($0 < session.tab.items.value.count - 1 ? session.tab.items.value.ids[$0 + 1] : session.tab.items.value.ids.first!)
            }
    }
    
    @objc func previousTab() {
        session
            .tab
            .items
            .value
            .ids
            .firstIndex(of: session.current.value)
            .map {
                session
                    .current
                    .send($0 > 0 ? session.tab.items.value.ids[$0 - 1] : session.tab.items.value.ids.last!)
            }
    }
    
    override func performTextFinderAction(_ sender: Any?) {
        (NSApp.keyWindow as? Window)
            .map {
                $0
                    .contentView?
                    .subviews
                    .compactMap {
                        $0 as? Browser
                    }
                    .first
                    .map {
                        $0.performTextFinderAction(sender)
                    }
            }
    }*/
}
