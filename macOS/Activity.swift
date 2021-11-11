import AppKit
import Combine

final class Activity: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 800, height: 400),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        animationBehavior = .alertPanel
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .menu
        contentView = content
        center()
        setFrameAutosaveName("Activity")
        
        let title = Text(vibrancy: true)
        title.font = .preferredFont(forTextStyle: .body)
        content.addSubview(title)
        
        let card = Card()
        content.addSubview(card)
        
        title.centerYAnchor.constraint(equalTo: content.topAnchor, constant: 26).isActive = true
        title.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -26).isActive = true
        
        card.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        card.leftAnchor.constraint(equalTo: content.leftAnchor, constant: 30).isActive = true
        card.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -30).isActive = true
        
        cloud
            .map(\.events.since)
            .removeDuplicates()
            .map {
                $0 == nil ? .now : $0!
            }
            .sink { since in
                title.attributedStringValue = .init(
                    .init("Activity since ", attributes: .init([
                        .foregroundColor: NSColor.labelColor]))
                    + .init(since.formatted(.relative(presentation: .named, unitsStyle: .wide)), attributes: .init([
                        .foregroundColor: NSColor.secondaryLabelColor])))
            }
            .store(in: &subs)
    }
    
    @objc func triggerCloseTab() {
        close()
    }
}
