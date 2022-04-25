import AppKit
import Combine

final class Learn: NSWindow {
    let item = CurrentValueSubject<_, Never>(Item.purchases)
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 700, height: 420),
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
        
        let side = NSVisualEffectView()
        side.translatesAutoresizingMaskIntoConstraints = false
        side.state = .active
        side.material = .hudWindow
        content.addSubview(side)
        
        let separator = Separator()
        side.addSubview(separator)
        
        let flip = Flip()
        flip.translatesAutoresizingMaskIntoConstraints = false
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.documentView = flip
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.drawsBackground = false
        scroll.scrollerInsets.top = 5
        scroll.scrollerInsets.bottom = 5
        scroll.automaticallyAdjustsContentInsets = false
        content.addSubview(scroll)
        
        let text = Text(vibrancy: true)
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        flip.addSubview(text)
        
        let menu = Stack(views: Item
            .allCases
            .map { item in
                let button = Action(item: item)
                button
                    .click
                    .sink { [weak self] in
                        self?.item.send(item)
                    }
                    .store(in: &subs)
                
                self
                    .item
                    .removeDuplicates()
                    .sink {
                        button.state = $0 == item ? .selected : .on
                    }
                    .store(in: &subs)
                return button
            })
        menu.orientation = .vertical
        menu.alignment = .leading
        menu.translatesAutoresizingMaskIntoConstraints = false
        menu.spacing = 1
        side.addSubview(menu)
        
        side.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        side.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        side.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        side.widthAnchor.constraint(equalToConstant: 240).isActive = true
        
        separator.rightAnchor.constraint(equalTo: side.rightAnchor).isActive = true
        separator.topAnchor.constraint(equalTo: side.topAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: side.bottomAnchor).isActive = true
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        menu.leftAnchor.constraint(equalTo: side.leftAnchor).isActive = true
        menu.topAnchor.constraint(equalTo: side.topAnchor, constant: 60).isActive = true
        menu.rightAnchor.constraint(equalTo: separator.leftAnchor).isActive = true
        
        scroll.topAnchor.constraint(equalTo: content.topAnchor, constant: 1).isActive = true
        scroll.leftAnchor.constraint(equalTo: side.rightAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -1).isActive = true
        scroll.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -1).isActive = true
        
        flip.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        flip.leftAnchor.constraint(equalTo: scroll.leftAnchor).isActive = true
        flip.rightAnchor.constraint(equalTo: scroll.rightAnchor).isActive = true
        
        text.topAnchor.constraint(equalTo: flip.topAnchor, constant: 30).isActive = true
        text.leftAnchor.constraint(equalTo: flip.leftAnchor, constant: 30).isActive = true
        text.rightAnchor.constraint(equalTo: flip.rightAnchor, constant: -30).isActive = true
        text.bottomAnchor.constraint(equalTo: flip.bottomAnchor, constant: -30).isActive = true
        
        item
            .sink { item in
                text.attributedStringValue = .with(markdown: item.info,
                                                   attributes: [
                                                    .foregroundColor: NSColor.labelColor,
                                                    .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular)])
            }
            .store(in: &subs)
    }
}
