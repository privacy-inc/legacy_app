import AppKit
import Combine
import StoreKit
import Specs

final class Window: NSWindow, NSWindowDelegate, NSTextFinderBarContainer {
    let session: Session
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
        
        let downloads = NSTitlebarAccessoryViewController()
        downloads.view = Downloads(session: session)
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
                content
                    .subviews
                    .forEach {
                        $0.removeFromSuperview()
                    }

                switch item.flow {
                case .list:
                    self?.isFindBarVisible = false
                    self?.finder.client = nil
                    place(Landing(session: session))
                    session.filter.send("")
                case let .web(web):
                    self?.finder.client = web
                    place(web)
                case let .message(_, info):
                    self?.isFindBarVisible = false
                    self?.finder.client = nil
                    place(Message(info: info))
                }
            }
            .store(in: &subs)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            switch Defaults.action {
            case .rate:
                SKStoreReviewController.requestReview()
            case .froob:
                self?.froob(bar: bar.view)
            case .none:
                break
            }
        }
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
        session.focus.send()
    }
    
    @objc override func triggerCloseTab() {
        guard session.items.value.count > 1 else {
            close()
            return
        }
        session.close(id: session.current.value)
    }
    
    @objc func triggerNextTab() {
        session.next(id: session.current.value)
    }
    
    @objc func triggerPreviousTab() {
        session.previous(id: session.current.value)
    }
    
    private func froob(bar: NSView) {
        let view = NSView(frame: .init(origin: .zero, size: .init(width: 350, height: 300)))
        
        let text = Text(vibrancy: true)
        text.attributedStringValue = .make {
            $0.append(.make("Support Privacy Browser", attributes: [
                .font: NSFont.preferredFont(forTextStyle: .title3),
                .foregroundColor: NSColor.labelColor]))
            $0.newLine()
            $0.append(.with(markdown: Copy.froob, attributes: [
                .font: NSFont.preferredFont(forTextStyle: .body),
                .foregroundColor: NSColor.secondaryLabelColor]))
        }
        
        let action = Control.Title("Continue", color: .labelColor, layer: true)
        action
            .click
            .sink {
                NSApp.orderFrontStandardAboutPanel(nil)
            }
            .store(in: &subs)
        
        let stack = NSStackView(views: [text, action])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        stack.spacing = 30
        view.addSubview(stack)
        
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        text.widthAnchor.constraint(equalToConstant: 260).isActive = true
        
        NSPopover().show(view, from: bar, edge: .minY)
    }
}
