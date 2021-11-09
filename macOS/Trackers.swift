import AppKit
import Combine

final class Trackers: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 600, height: 500),
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
        setFrameAutosaveName("Trackers")
        
        let title = Text(vibrancy: false)
        content.addSubview(title)
        
        title.centerYAnchor.constraint(equalTo: content.topAnchor, constant: 26).isActive = true
        title.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -26).isActive = true
        
        cloud
            .map(\.events)
            .sink { events in
                let count = events.prevented
                title.attributedStringValue = .init(.init(count.formatted(), attributes: .init([
                    .font: NSFont.monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular),
                    .foregroundColor: NSColor.labelColor]))
                                                    + .init(count == 1 ? " tracker so far" : " total trackers", attributes: .init([
                                                        .font: NSFont.preferredFont(forTextStyle: .body),
                                                        .foregroundColor: NSColor.secondaryLabelColor])))
            }
            .store(in: &subs)
    }
    
    @objc func triggerCloseTab() {
        close()
    }
}
