import AppKit

final class Preferences: NSWindow {
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 500, height: 460),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        animationBehavior = .alertPanel
        toolbar = .init()
        titlebarAppearsTransparent = true
        isReleasedWhenClosed = false
        center()
        setFrameAutosaveName("Preferences")
        center()
        
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .sidebar
        contentView = content
        
        let tab = NSTabView()
        tab.translatesAutoresizingMaskIntoConstraints = false
        tab.addTabViewItem(General())
        tab.addTabViewItem(Navigation())
        tab.addTabViewItem(Features())
        tab.addTabViewItem(Javascript())
        contentView!.addSubview(tab)
        
        tab.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor).isActive = true
        tab.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        tab.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        tab.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
    }
    
    @objc func triggerCloseTab() {
        close()
    }
}
