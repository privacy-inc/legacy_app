import AppKit
import Combine

private let width = CGFloat(420)

final class Shortcut: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .init(origin: .zero, size: .init(width: width, height: 480)))
        
        let separator = Separator()
        addSubview(separator)
        
        let background = NSVisualEffectView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.material = .hudWindow
        background.state = .active
        addSubview(background)
        
        let configure = Control.Symbol("slider.vertical.3", point: 18, size: 40, weight: .light, hierarchical: true)
        configure
            .click
            .sink {
                NSApp.activate(ignoringOtherApps: true)
                (NSApp as! App).showPreferencesWindow(nil)
            }
            .store(in: &subs)
        addSubview(configure)
        
        let forget = Control.Symbol("flame", point: 18, size: 40, weight: .light, hierarchical: true)
        forget
            .click
            .sink {
                NSPopover().show(Forget(), from: forget, edge: .maxY)
            }
            .store(in: &subs)
        addSubview(forget)
        
        let flip = Flip()
        flip.translatesAutoresizingMaskIntoConstraints = false
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.documentView = flip
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.drawsBackground = false
        scroll.scrollerInsets.top = 5
        scroll.scrollerInsets.bottom = 5
        scroll.automaticallyAdjustsContentInsets = false
        background.addSubview(scroll)
        
        let stack = Stack()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        stack.spacing = 2
        flip.addSubview(stack)
        
        background.topAnchor.constraint(equalTo: topAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: separator.topAnchor).isActive = true
        
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        configure.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        configure.rightAnchor.constraint(equalTo: forget.leftAnchor, constant: -10).isActive = true
        
        forget.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        forget.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        scroll.topAnchor.constraint(equalTo: background.topAnchor, constant: 1).isActive = true
        scroll.leftAnchor.constraint(equalTo: background.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: background.rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: background.bottomAnchor).isActive = true
        
        flip.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        flip.leftAnchor.constraint(equalTo: scroll.leftAnchor).isActive = true
        flip.rightAnchor.constraint(equalTo: scroll.rightAnchor).isActive = true
        flip.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20).isActive = true
        
        stack.topAnchor.constraint(equalTo: flip.topAnchor, constant: 20).isActive = true
        stack.leftAnchor.constraint(equalTo: flip.leftAnchor, constant: 15).isActive = true
        stack.widthAnchor.constraint(equalToConstant: width - 30).isActive = true
        
        let items = NSApp
            .windows
            .compactMap {
                $0 as? Window
            }
            .flatMap { window in
                window
                    .session
                    .items
                    .value
                    .map {
                        (window: window, item: $0)
                    }
            }
        
        stack.setViews(items
            .map {
                Item(window: $0.window, item: $0.item)
            }, in: .center)
        
        if let index = items.firstIndex (where: {
            $0.window == NSApp.mainWindow && $0.window.session.current.value == $0.item.id
        }) {
            flip.layoutSubtreeIfNeeded()
            scroll.contentView.bounds.origin.y = .init(index * 41) - 120
        }
    }
}
