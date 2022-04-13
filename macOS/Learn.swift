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
        
        let border = Vibrant(layer: true)
        border.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
        side.addSubview(border)
        
        let selector = Vibrant(layer: true)
        selector.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
        side.addSubview(selector)
        
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
        
        let menu = NSStackView(views: Item
            .allCases
            .map { item in
                let button = Control.Title(item.title, color: .labelColor, layer: false)
                button
                    .click
                    .sink { [weak self] in
                        self?.item.send(item)
                    }
                    .store(in: &subs)
                return button
            })
        menu.orientation = .vertical
        menu.alignment = .leading
        menu.translatesAutoresizingMaskIntoConstraints = false
        menu.spacing = 20
        side.addSubview(menu)
        
        side.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        side.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        side.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        side.widthAnchor.constraint(equalToConstant: 240).isActive = true
        
        border.rightAnchor.constraint(equalTo: side.rightAnchor).isActive = true
        border.topAnchor.constraint(equalTo: side.topAnchor).isActive = true
        border.bottomAnchor.constraint(equalTo: side.bottomAnchor).isActive = true
        border.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        selector.leftAnchor.constraint(equalTo: side.leftAnchor).isActive = true
        selector.rightAnchor.constraint(equalTo: border.leftAnchor).isActive = true
        selector.heightAnchor.constraint(equalToConstant: 35).isActive = true
        let selectorCenter = selector.centerYAnchor.constraint(equalTo: side.topAnchor)
        selectorCenter.isActive = true
        
        menu.leftAnchor.constraint(equalTo: side.leftAnchor, constant: 10).isActive = true
        menu.topAnchor.constraint(equalTo: side.topAnchor, constant: 60).isActive = true
        menu.rightAnchor.constraint(equalTo: border.leftAnchor).isActive = true
        
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
                selectorCenter.constant = 75 + (47 * .init(item.rawValue))
                text.attributedStringValue = .with(markdown: item.info,
                                                   attributes: [
                                                    .foregroundColor: NSColor.labelColor,
                                                    .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular)])
            }
            .store(in: &subs)
    }
}
