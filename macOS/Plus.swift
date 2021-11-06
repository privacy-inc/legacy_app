import AppKit
import Combine
import Specs

final class Plus: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 520, height: 680),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        setFrameAutosaveName("Plus")
        
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .menu
        contentView = content
        center()
        
        let image = Image(named: "Plus", vibrancy: true)
        image.imageScaling = .scaleNone
        content.addSubview(image)
        
        let title = Text(vibrancy: true)
        title.stringValue = "Privacy"
        title.font = NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title1).pointSize, weight: .regular)
        title.textColor = .labelColor
        content.addSubview(title)
        
        let plus = Image(icon: "plus")
        plus.symbolConfiguration = .init(pointSize: 48, weight: .ultraLight)
            .applying(.init(hierarchicalColor: .labelColor))
        content.addSubview(plus)
        
        let why = Option(title: "Why In-App Purchases", image: "questionmark.app.dashed")
        content.addSubview(why)
        why
            .click
            .sink {
                let pop = Pop(title: "Why In-App Purchases", copy: Copy.why)
                pop.show(relativeTo: why.bounds, of: why, preferredEdge: .minY)
                pop.contentViewController!.view.window!.makeKey()
            }
            .store(in: &subs)
        
        let alternatives = Option(title: "Alternatives", image: "arrow.triangle.branch")
        content.addSubview(alternatives)
        alternatives
            .click
            .sink {
                let pop = Pop(title: "Alternatives", copy: Copy.alternatives)
                pop.show(relativeTo: alternatives.bounds, of: alternatives, preferredEdge: .minY)
                pop.contentViewController!.view.window!.makeKey()
            }
            .store(in: &subs)
        
        var inner: NSView?
        
        store
            .status
            .sink { status in
                inner?.removeFromSuperview()
                
//                if Defaults.isPremium {
                    inner = Purchased()
//                } else {
//                    switch status {
//                        
//                    }
//                }
                
                inner!.translatesAutoresizingMaskIntoConstraints = false
                content.addSubview(inner!)
                inner!.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 30).isActive = true
                inner!.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
                inner!.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
                inner!.bottomAnchor.constraint(equalTo: why.topAnchor, constant: -30).isActive = true
            }
            .store(in: &subs)
        
        image.topAnchor.constraint(equalTo: content.topAnchor, constant: 60).isActive = true
        image.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        title.topAnchor.constraint(equalTo: image.bottomAnchor).isActive = true
        title.centerXAnchor.constraint(equalTo: content.centerXAnchor, constant: -22).isActive = true
        
        plus.centerYAnchor.constraint(equalTo: title.centerYAnchor).isActive = true
        plus.leftAnchor.constraint(equalTo: title.rightAnchor).isActive = true
        
        why.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        why.bottomAnchor.constraint(equalTo: alternatives.topAnchor, constant: -10).isActive = true
        
        alternatives.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        alternatives.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -50).isActive = true
    }
}
