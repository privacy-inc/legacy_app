import AppKit

final class Trackers: NSWindow {
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
        title.stringValue = "46 trackers"
        title.textColor = .secondaryLabelColor
        content.addSubview(title)
        
        title.centerYAnchor.constraint(equalTo: content.topAnchor, constant: 26).isActive = true
        title.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -20).isActive = true
    }
    
    @objc func triggerCloseTab() {
        close()
    }
}
