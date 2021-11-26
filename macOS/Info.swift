import AppKit
import Combine

class Info: NSWindow {
    private var sub: AnyCancellable?
    
    init(title: String, copy: String) {
        super.init(contentRect: .init(x: 0, y: 0, width: 540, height: 400),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        animationBehavior = .alertPanel
        toolbar = .init()
        isMovableByWindowBackground = true
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .menu
        contentView = content
        center()
        
        let header = Text(vibrancy: true)
        header.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title2).pointSize, weight: .regular)
        header.textColor = .labelColor
        header.stringValue = title
        content.addSubview(header)
        
        let flip = Flip()
        flip.translatesAutoresizingMaskIntoConstraints = false
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.documentView = flip
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.drawsBackground = false
        scroll.scrollerInsets.bottom = 10
        scroll.automaticallyAdjustsContentInsets = false
        scroll.postsBoundsChangedNotifications = true
        content.addSubview(scroll)
        
        let separator = Separator(mode: .horizontal)
        separator.isHidden = true
        content.addSubview(separator)
        
        let text = Text(vibrancy: true)
        text.maximumNumberOfLines = 0
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        text.attributedStringValue = .with(markdown: copy, attributes: [
            .font: NSFont.preferredFont(forTextStyle: .title3),
            .foregroundColor: NSColor.secondaryLabelColor])
        flip.addSubview(text)
        
        header.centerYAnchor.constraint(equalTo: content.topAnchor, constant: 28).isActive = true
        header.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        scroll.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -1).isActive = true
        scroll.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -1).isActive = true
        
        flip.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        flip.leftAnchor.constraint(equalTo: scroll.leftAnchor).isActive = true
        flip.rightAnchor.constraint(equalTo: scroll.rightAnchor).isActive = true
        
        separator.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 15).isActive = true
        separator.leftAnchor.constraint(equalTo: text.leftAnchor, constant: -40).isActive = true
        separator.rightAnchor.constraint(equalTo: text.rightAnchor, constant: 40).isActive = true
        
        text.topAnchor.constraint(equalTo: flip.topAnchor, constant: 25).isActive = true
        text.leftAnchor.constraint(equalTo: flip.leftAnchor, constant: 70).isActive = true
        text.rightAnchor.constraint(equalTo: flip.rightAnchor, constant: -70).isActive = true
        text.bottomAnchor.constraint(equalTo: flip.bottomAnchor, constant: -50).isActive = true
        
        sub = NotificationCenter
            .default
            .publisher(for: NSView.boundsDidChangeNotification)
            .compactMap {
                $0.object as? NSClipView
            }
            .filter {
                $0 == scroll.contentView
            }
            .map {
                $0.bounds.minY < 20
            }
            .removeDuplicates()
            .sink {
                separator.isHidden = $0
            }
    }
}
