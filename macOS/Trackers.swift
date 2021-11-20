import AppKit
import Combine

final class Trackers: NSWindow {
    static let width = CGFloat(500)
    private weak var list: List!
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: Self.width, height: 500),
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
        
        let title = Text(vibrancy: true)
        content.addSubview(title)
        
        let list = List()
        self.list = list
        content.addSubview(list)
        
        title.centerYAnchor.constraint(equalTo: content.topAnchor, constant: 26).isActive = true
        title.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -26).isActive = true
        
        list.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor).isActive = true
        list.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        list.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -1).isActive = true
        
        cloud
            .map(\.events.prevented)
            .removeDuplicates()
            .sink { count in
                title.attributedStringValue = .make {
                    $0.append(.make(count.formatted(), attributes: [
                        .font: NSFont.monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular),
                        .foregroundColor: NSColor.labelColor]))
                    $0.append(.make(count == 1 ? " tracker so far" : " total trackers", attributes: [
                        .font: NSFont.preferredFont(forTextStyle: .body),
                        .foregroundColor: NSColor.tertiaryLabelColor]))
                }
            }
            .store(in: &subs)
    }
    
    @objc func triggerCloseTab() {
        list.pop?.close()
        close()
    }
}
