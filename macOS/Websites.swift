import AppKit
import Combine

class Websites: NSWindow {
    final var subs = Set<AnyCancellable>()
    private(set) weak var navigation: Text!
    private(set) weak var list: List!
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 600, height: 400),
                   styleMask: [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        minSize = .init(width: 300, height: 200)
        animationBehavior = .alertPanel
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .menu
        contentView = content
        center()
        
        let navigation = Text(vibrancy: true)
        self.navigation = navigation
        content.addSubview(navigation)
        
        let list = List()
        self.list = list
        content.addSubview(list)
        
        navigation.centerYAnchor.constraint(equalTo: content.topAnchor, constant: 26).isActive = true
        navigation.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -26).isActive = true
        
        list.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor).isActive = true
        list.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        list.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -1).isActive = true
    }
    
    @objc final func triggerCloseTab() {
        close()
    }
}
