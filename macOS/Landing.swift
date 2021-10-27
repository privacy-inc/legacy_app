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
        
        let guide = NSView()
        guide.translatesAutoresizingMaskIntoConstraints = false
        flip.addSubview(guide)
        
        flip.translatesAutoresizingMaskIntoConstraints = false
        flip.topAnchor.constraint(equalTo: topAnchor).isActive = true
        flip.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        flip.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor).isActive = true
        flip.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        guide.leftAnchor.constraint(greaterThanOrEqualTo: flip.leftAnchor, constant: 20).isActive = true
        guide.rightAnchor.constraint(lessThanOrEqualTo: flip.rightAnchor, constant: -20).isActive = true
        guide.widthAnchor.constraint(lessThanOrEqualToConstant: 600).isActive = true
        guide.centerXAnchor.constraint(equalTo: flip.centerXAnchor).isActive = true
        let width = guide.widthAnchor.constraint(equalTo: flip.widthAnchor, constant: -40)
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
                
                var top = flip.safeAreaLayoutGuide.topAnchor
                
                cards
                    .forEach {
                        switch $0.id {
                        case .trackers:
                            let trackers = Trackers()
                            flip.addSubview(trackers)
                            
                            trackers.topAnchor.constraint(equalTo: top).isActive = true
                            trackers.leftAnchor.constraint(equalTo: guide.leftAnchor).isActive = true
                            trackers.rightAnchor.constraint(equalTo: guide.rightAnchor).isActive = true
                            top = trackers.bottomAnchor
                        case .activity:
                            break
                        case .bookmarks:
                            break
                        case .history:
                            break
                        }
                    }
            }
            .store(in: &subs)
    }
}
