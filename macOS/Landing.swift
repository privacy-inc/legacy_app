import AppKit
import Combine
import Specs

final class Landing: NSView {
    private var subs = Set<AnyCancellable>()

    required init?(coder: NSCoder) { nil }
    init(status: Status) {
        super.init(frame: .zero)
        /*
        let separator = Separator(mode: .horizontal)
        separator.isHidden = true
        addSubview(separator)
        
        let flip = Flip()
        flip.translatesAutoresizingMaskIntoConstraints = false
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.documentView = flip
        scroll.drawsBackground = false
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.scrollerInsets.bottom = 12
        scroll.automaticallyAdjustsContentInsets = false
        addSubview(scroll)
        
        let guide = NSView()
        guide.translatesAutoresizingMaskIntoConstraints = false
        flip.addSubview(guide)
        
        let configure = Option(icon: "slider.vertical.3")
        configure
            .click
            .sink {
                let pop = Edit()
                pop.show(relativeTo: configure.bounds, of: configure, preferredEdge: .maxY)
                pop.contentViewController!.view.window!.makeKey()
            }
            .store(in: &subs)
        
        let forget = Option(icon: "flame")
        forget
            .click
            .sink {
                let pop = Forgetting(behaviour: .semitransient)
                pop.show(relativeTo: forget.bounds, of: forget, preferredEdge: .maxY)
                pop.contentViewController!.view.window!.makeKey()
            }
            .store(in: &subs)
        
        let bookmarks = Option(icon: "bookmark")
        bookmarks
            .click
            .sink {
                NSApp.showBookmarks()
            }
            .store(in: &subs)
        
        let history = Option(icon: "clock")
        history
            .click
            .sink {
                NSApp.showHistory()
            }
            .store(in: &subs)
        
        let stack = NSStackView(views: [bookmarks, history, forget, configure])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        addSubview(stack)
        
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -27).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        
        
        separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).isActive = true
        
        scroll.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        flip.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        flip.leftAnchor.constraint(equalTo: scroll.leftAnchor).isActive = true
        flip.rightAnchor.constraint(equalTo: scroll.rightAnchor).isActive = true
        flip.bottomAnchor.constraint(greaterThanOrEqualTo: scroll.bottomAnchor).isActive = true

        guide.topAnchor.constraint(equalTo: flip.topAnchor).isActive = true
        guide.heightAnchor.constraint(equalToConstant: 0).isActive = true
        guide.leftAnchor.constraint(greaterThanOrEqualTo: flip.leftAnchor, constant: 150).isActive = true
        guide.rightAnchor.constraint(lessThanOrEqualTo: flip.rightAnchor, constant: -150).isActive = true
        guide.widthAnchor.constraint(lessThanOrEqualToConstant: 500).isActive = true
        guide.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        let width = guide.widthAnchor.constraint(equalTo: flip.widthAnchor, constant: -300)
        width.priority = .defaultLow
        width.isActive = true
        
        cloud
            .filter {
                $0.timestamp > 0
            }
            .map {
                $0
                    .cards
                    .filter(\.state)
            }
            .removeDuplicates()
            .sink { cards in
                flip
                    .subviews
                    .filter {
                        $0 != guide
                    }
                    .forEach {
                        $0.removeFromSuperview()
                    }
                
                var top = guide.topAnchor
                
                cards
                    .forEach {
                        let section: Section
                        
                        switch $0.id {
                        case .trackers:
                            section = Trackers()
                        case .activity:
                            section = Activity()
                        case .bookmarks:
                            section = Bookmarks(status: status)
                        case .history:
                            section = History(status: status)
                        }
                        
                        flip.addSubview(section)
                        
                        section.topAnchor.constraint(equalTo: top, constant: top == guide.topAnchor ? 40 : 60).isActive = true
                        section.leftAnchor.constraint(equalTo: guide.leftAnchor).isActive = true
                        section.rightAnchor.constraint(equalTo: guide.rightAnchor).isActive = true
                        top = section.bottomAnchor
                    }
                
                if !cards.isEmpty {
                    flip.bottomAnchor.constraint(greaterThanOrEqualTo: top, constant: 60).isActive = true
                }
            }
            .store(in: &subs)
        
        NotificationCenter
            .default
            .publisher(for: NSView.boundsDidChangeNotification)
            .compactMap {
                $0.object as? NSClipView
            }
            .filter {
                $0 == scroll.contentView
            }
            .map {
                $0.bounds.minY < 30
            }
            .removeDuplicates()
            .sink {
                separator.isHidden = $0
            }
            .store(in: &subs)
         
         */
    }
    
    override func mouseDown(with: NSEvent) {
        super.mouseDown(with: with)
        if with.clickCount == 1 {
            window?.makeFirstResponder(self)
        }
    }
}
