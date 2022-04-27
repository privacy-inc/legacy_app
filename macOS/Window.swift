import AppKit
import Combine

final class Window: NSWindow, NSWindowDelegate, NSTextFinderBarContainer {
    let session: Session
    let downloads = Downloads()
    let finder = NSTextFinder()
    private weak var findbar: NSTitlebarAccessoryViewController!
    private var subs = Set<AnyCancellable>()
    
    init(session: Session) {
        self.session = session
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
        bar.view = Bar(session: session)
        bar.layoutAttribute = .top
        addTitlebarAccessoryViewController(bar)
        
        let accessory = NSTitlebarAccessoryViewController()
        accessory.view = downloads
        accessory.view.frame.size.height = 100
        accessory.layoutAttribute = .bottom
        addTitlebarAccessoryViewController(accessory)

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

        session
            .items
            .combineLatest(session
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
                switch item.flow {
                case .list:
                    self?.isFindBarVisible = false
                    self?.finder.client = nil
                    self?.place(view: Landing(session: session))
                    session.filter.send("")
                case let .web(web):
                    self?.finder.client = web
                    self?.place(view: web)
                case let .message(_, info):
                    self?.isFindBarVisible = false
                    self?.finder.client = nil
                    self?.place(view: Message(info: info))
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
    
    override func close() {
        super.close()
        session.items.value = []
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
        session.focus.send()
    }

    @objc func triggerNextTab() {
        session.next(id: session.current.value)
    }
    
    @objc func triggerPreviousTab() {
        session.previous(id: session.current.value)
    }
    
    @objc override func triggerCloseTab() {
        guard session.items.value.count > 1 else {
            close()
            return
        }
        session.close(id: session.current.value)
    }
    
    private func place(view: NSView) {
        guard let content = contentView else { return }
        
        content
            .subviews
            .forEach {
                $0.removeFromSuperview()
            }
        
        content.addSubview(view)
        makeFirstResponder(view)

        view.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
    }
}
