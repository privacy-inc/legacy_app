import AppKit
import Combine

class Websites: NSWindow {
    final var subs = Set<AnyCancellable>()
    private(set) weak var navigation: Text!
    private(set) weak var list: List!
    private(set) weak var icon: Image!
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 400, height: 400),
                   styleMask: [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        minSize = .init(width: 260, height: 140)
        animationBehavior = .alertPanel
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .menu
        contentView = content
        center()
        
        let vibrant = Vibrant(layer: false)
        vibrant.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(vibrant)
        
        let separator = Separator(mode: .horizontal)
        separator.isHidden = true
        content.addSubview(separator)
        
        let navigation = Text(vibrancy: true)
        navigation.font = .preferredFont(forTextStyle: .title3)
        navigation.textColor = .tertiaryLabelColor
        self.navigation = navigation
        vibrant.addSubview(navigation)
        
        let icon = Image()
        icon.symbolConfiguration = .init(textStyle: .title3, scale: .large)
            .applying(.init(hierarchicalColor: .tertiaryLabelColor))
        self.icon = icon
        vibrant.addSubview(icon)
        
        let list = List()
        self.list = list
        content.addSubview(list)
        
        vibrant.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        vibrant.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -26).isActive = true
        vibrant.heightAnchor.constraint(equalToConstant: 52).isActive = true
        vibrant.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        navigation.centerYAnchor.constraint(equalTo: vibrant.centerYAnchor).isActive = true
        navigation.rightAnchor.constraint(equalTo: icon.leftAnchor, constant: -6).isActive = true
        
        icon.rightAnchor.constraint(equalTo: vibrant.rightAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: vibrant.centerYAnchor).isActive = true
        
        separator.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: content.leftAnchor, constant: 2).isActive = true
        separator.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -2).isActive = true
        
        list.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor).isActive = true
        list.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        list.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -1).isActive = true
        
        NotificationCenter
            .default
            .publisher(for: NSView.boundsDidChangeNotification)
            .compactMap {
                $0.object as? NSClipView
            }
            .filter {
                $0 == list.contentView
            }
            .map {
                $0.bounds.minY < 35
            }
            .removeDuplicates()
            .sink {
                separator.isHidden = $0
            }
            .store(in: &subs)
    }
    
    @objc final func triggerCloseTab() {
        close()
    }
}
