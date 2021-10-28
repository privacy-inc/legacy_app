import AppKit
import Combine
import Specs

final class Landing: NSScrollView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let flip = Flip()
        documentView = flip
        drawsBackground = false
        hasVerticalScroller = true
        verticalScroller!.controlSize = .mini
        scrollerInsets.top = 12
        scrollerInsets.bottom = 12
        automaticallyAdjustsContentInsets = false
        
        let guide = NSView()
        guide.translatesAutoresizingMaskIntoConstraints = false
        flip.addSubview(guide)
        
        flip.translatesAutoresizingMaskIntoConstraints = false
        flip.topAnchor.constraint(equalTo: topAnchor).isActive = true
        flip.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        flip.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        flip.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor).isActive = true

        guide.topAnchor.constraint(equalTo: flip.topAnchor).isActive = true
        guide.heightAnchor.constraint(equalToConstant: 0).isActive = true
        guide.leftAnchor.constraint(greaterThanOrEqualTo: flip.leftAnchor, constant: 60).isActive = true
        guide.rightAnchor.constraint(lessThanOrEqualTo: flip.rightAnchor, constant: -60).isActive = true
        guide.widthAnchor.constraint(lessThanOrEqualToConstant: 600).isActive = true
        guide.centerXAnchor.constraint(equalTo: flip.centerXAnchor).isActive = true
        let width = guide.widthAnchor.constraint(equalTo: flip.widthAnchor, constant: -120)
        width.priority = .defaultLow
        width.isActive = true
        
        cloud
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
                            section = Bookmarks()
                        case .history:
                            section = Activity()
                        }
                        
                        flip.addSubview(section)
                        
                        section.topAnchor.constraint(equalTo: top, constant: top == guide.topAnchor ? 100 : 60).isActive = true
                        section.leftAnchor.constraint(equalTo: guide.leftAnchor).isActive = true
                        section.rightAnchor.constraint(equalTo: guide.rightAnchor).isActive = true
                        top = section.bottomAnchor
                    }
                
                if !cards.isEmpty {
                    flip.bottomAnchor.constraint(greaterThanOrEqualTo: top, constant: 60).isActive = true
                }
            }
            .store(in: &subs)
    }
}
