import AppKit
import Combine

final class Window: NSWindow, NSWindowDelegate {
    let status: Status
    private var subs = Set<AnyCancellable>()
    
    init(status: Status) {
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
        
//        let bottom = NSTitlebarAccessoryViewController()
//        bottom.view = Subbar(status: status)
//        bottom.layoutAttribute = .bottom
//        addTitlebarAccessoryViewController(bottom)
        #warning("use for downloads")

        let findbar = Findbar()
        addTitlebarAccessoryViewController(findbar)
        
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .menu
        content.translatesAutoresizingMaskIntoConstraints = false
        contentView = content
        
        let place = { [weak self] (view: NSView) -> Void in
            content.addSubview(view)
            self?.makeFirstResponder(view)

            view.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
            view.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        }
        
        status
            .items
            .combineLatest(status
                            .current)
            .compactMap { items, current in
                items
                    .first {
                        $0.id == current
                    }
            }
            .removeDuplicates()
            .removeDuplicates {
                $0.flow == .list && $1.flow == .list
            }
            .sink { item in
                content
                    .subviews
                    .forEach {
                        $0.removeFromSuperview()
                    }

                switch item.flow {
                case .list:
                    place(List(status: status, id: item.id))
                    findbar.isHidden = true
                    Task {
                        await status.websites.send(cloud.list(filter: ""))
                    }
                case let .web(web):
//                    self.finder.client = web
                    place(web)
                    findbar.isHidden = false
                case let .error(_, error):
                    place(Recover(error: error))
                    findbar.isHidden = true
                }
            }
            .store(in: &subs)
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
        status.focus.send()
    }
    
    @objc func triggerCloseTab() {
        guard status.items.value.count > 1 else {
            close()
            return
        }
        status.close(id: status.current.value)
    }
    
    @objc func triggerNextTab() {
//        status.nextTab()
    }
    
    @objc func triggerPreviousTab() {
//        status.previousTab()
    }
}
