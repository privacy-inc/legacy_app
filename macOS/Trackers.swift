/*import AppKit
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
        
        let vibrant = Vibrant(layer: false)
        vibrant.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(vibrant)
        
        let separator = Separator(mode: .horizontal)
        separator.isHidden = true
        content.addSubview(separator)
        
        let icon = Image(icon: "shield.lefthalf.filled")
        icon.symbolConfiguration = .init(textStyle: .title3, scale: .large)
            .applying(.init(hierarchicalColor: .tertiaryLabelColor))
        vibrant.addSubview(icon)
        
        let title = Text(vibrancy: true)
        vibrant.addSubview(title)
        
        let list = List()
        self.list = list
        content.addSubview(list)
        
        vibrant.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        vibrant.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -26).isActive = true
        vibrant.heightAnchor.constraint(equalToConstant: 52).isActive = true
        vibrant.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        title.centerYAnchor.constraint(equalTo: vibrant.centerYAnchor).isActive = true
        title.rightAnchor.constraint(equalTo: icon.leftAnchor, constant: -6).isActive = true
        
        icon.rightAnchor.constraint(equalTo: vibrant.rightAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: vibrant.centerYAnchor).isActive = true
        
        separator.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: content.leftAnchor, constant: 2).isActive = true
        separator.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -2).isActive = true
        
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
                        .font: NSFont.monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular),
                        .foregroundColor: NSColor.labelColor]))
                    $0.append(.make(count == 1 ? " tracker so far" : " total trackers", attributes: [
                        .font: NSFont.preferredFont(forTextStyle: .title3),
                        .foregroundColor: NSColor.tertiaryLabelColor]))
                }
            }
            .store(in: &subs)
        
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
    
    @objc func triggerCloseTab() {
        list.pop?.close()
        close()
    }
}
*/
