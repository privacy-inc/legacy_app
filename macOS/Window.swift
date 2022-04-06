import AppKit
import Combine

final class Window: NSWindow, NSWindowDelegate, NSTextFinderBarContainer {
    let status: Status
    let finder = NSTextFinder()
    private weak var findbar: NSTitlebarAccessoryViewController!
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
        finder.findBarContainer = self
        
        let bar = NSTitlebarAccessoryViewController()
        bar.view = Bar(status: status)
        bar.layoutAttribute = .top
        addTitlebarAccessoryViewController(bar)
        
        let downloads = NSTitlebarAccessoryViewController()
        downloads.view = Downloads(status: status)
        downloads.view.frame.size.height = 1
        downloads.layoutAttribute = .bottom
        addTitlebarAccessoryViewController(downloads)

        let findbar = NSTitlebarAccessoryViewController()
        findbar.view = .init()
        findbar.view.frame.size.height = 1
        findbar.layoutAttribute = .bottom
        addTitlebarAccessoryViewController(findbar)
        self.findbar = findbar
        
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
            .sink { [weak self] item in
                content
                    .subviews
                    .forEach {
                        $0.removeFromSuperview()
                    }

                switch item.flow {
                case .list:
                    self?.isFindBarVisible = false
                    self?.finder.client = nil
                    place(List(status: status, id: item.id))
                    Task {
                        await status.websites.send(cloud.list(filter: ""))
                    }
                case let .web(web):
                    self?.finder.client = web
                    place(web)
                case let .message(_, url, title, icon):
                    self?.isFindBarVisible = false
                    self?.finder.client = nil
                    place(Message(url: url, title: title, icon: icon))
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
    
    var findBarView: NSView? {
        didSet {
            findBarView
                .map {
                    findbar.view = $0
                }
        }
    }
    
    var isFindBarVisible = false {
        didSet {
            if !isFindBarVisible {
                findbar.view = .init()
                findbar.view.frame.size.height = 1
            }
        }
    }
    
    func findBarViewDidChangeHeight() {
        
    }
    
    @objc override func performTextFinderAction(_ sender: Any?) {
        (sender as? NSMenuItem)
            .map(\.tag)
            .flatMap(NSTextFinder.Action.init(rawValue:))
            .map {
                guard finder.validateAction($0) else { return }
                finder.performAction($0)

                switch $0 {
                case .showFindInterface:
                    finder.findBarContainer?.isFindBarVisible = true
                default: break
                }
            }
    }
    
    @objc func triggerFocus() {
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
        status.next(id: status.current.value)
    }
    
    @objc func triggerPreviousTab() {
        status.previous(id: status.current.value)
    }
}
