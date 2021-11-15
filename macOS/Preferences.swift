import AppKit

final class Preferences: NSWindow {
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 600, height: 460),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        animationBehavior = .alertPanel
        toolbar = .init()
        titlebarAppearsTransparent = true
        isReleasedWhenClosed = false
        center()
        setFrameAutosaveName("Preferences")
        
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .sidebar
        contentView = content
        
        let tab = NSTabView()
        tab.translatesAutoresizingMaskIntoConstraints = false
        tab.addTabViewItem(General())
        tab.addTabViewItem(Browser())
        tab.addTabViewItem(Navigation())
        tab.addTabViewItem(Features())
        tab.addTabViewItem(Javascript())
        tab.addTabViewItem(Location())
        contentView!.addSubview(tab)
        
        let top = NSTitlebarAccessoryViewController()
        top.view = Bar()
        top.layoutAttribute = .top
        addTitlebarAccessoryViewController(top)
        
        tab.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        tab.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        tab.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        tab.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
    }
    
    @objc func triggerCloseTab() {
        close()
    }
}
