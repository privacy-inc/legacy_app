import AppKit

final class Preferences: NSWindow {
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 600, height: 400),
                   styleMask: [.closable, .miniaturizable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
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
        tab.addTabViewItem(Navigation())
        tab.addTabViewItem(Features())
        tab.addTabViewItem(Notifications())
        contentView!.addSubview(tab)
        
        tab.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        tab.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -10).isActive = true
        tab.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 10).isActive = true
        tab.rightAnchor.constraint(equalTo: contentView!.rightAnchor, constant: -10).isActive = true
    }
}
