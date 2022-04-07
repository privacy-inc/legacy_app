import AppKit
import Combine
import Specs

final class Plus: NSWindow {
    private var subs = Set<AnyCancellable>()
    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 520, height: 780),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        animationBehavior = .alertPanel
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        setFrameAutosaveName("Plus")
        
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .menu
        contentView = content
        center()
        
        let image = Image(named: "Plus")
        image.imageScaling = .scaleNone
        content.addSubview(image)
        
        let banner = Banner()
        content.addSubview(banner)
        
        let title = Text(vibrancy: true)
        title.stringValue = "Privacy"
        title.font = NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title1).pointSize, weight: .regular)
        title.textColor = .labelColor
        content.addSubview(title)
        
        let plus = Image(icon: "plus")
        plus.symbolConfiguration = .init(pointSize: 35, weight: .ultraLight)
            .applying(.init(hierarchicalColor: .labelColor))
        content.addSubview(plus)
        
        let why = Option(title: "Why purchases", image: "questionmark.app.dashed")
        content.addSubview(why)
        why
            .click
            .sink {
//                let pop = Pop(title: "Why purchases", copy: Copy.why)
//                pop.show(relativeTo: why.bounds, of: why, preferredEdge: .maxY)
//                pop.contentViewController!.view.window!.makeKey()
            }
            .store(in: &subs)
        
        let alternatives = Option(title: "Alternatives", image: "arrow.triangle.branch")
        content.addSubview(alternatives)
        alternatives
            .click
            .sink {
//                let pop = Pop(title: "Alternatives", copy: Copy.alternatives)
//                pop.show(relativeTo: alternatives.bounds, of: alternatives, preferredEdge: .maxY)
//                pop.contentViewController!.view.window!.makeKey()
            }
            .store(in: &subs)
        
        var inner: NSView?
        
        store
            .status
            .sink { status in
                inner?.removeFromSuperview()

                if Defaults.isPremium {
                    inner = Purchased()
                } else {
                    switch status {
                    case .loading:
                        inner = NSView()
                        
                        let image = Image(icon: "hourglass")
                        image.symbolConfiguration = .init(textStyle: .largeTitle)
                            .applying(.init(hierarchicalColor: .init(named: "Dawn")!))
                        inner!.addSubview(image)
                        
                        image.centerXAnchor.constraint(equalTo: inner!.centerXAnchor).isActive = true
                        image.centerYAnchor.constraint(equalTo: inner!.centerYAnchor).isActive = true
                        
                    case let .error(error):
                        inner = NSView()
                        
                        let text = Text(vibrancy: true)
                        text.font = .preferredFont(forTextStyle: .title3)
                        text.alignment = .center
                        text.textColor = .secondaryLabelColor
                        text.stringValue = error
                        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                        inner!.addSubview(text)
                        
                        text.centerXAnchor.constraint(equalTo: inner!.centerXAnchor).isActive = true
                        text.centerYAnchor.constraint(equalTo: inner!.centerYAnchor).isActive = true
                        text.widthAnchor.constraint(equalToConstant: 300).isActive = true
                        
                    case let .products(products):
                        inner = Item(product: products.first!)
                    }
                }
                
                inner!.translatesAutoresizingMaskIntoConstraints = false
                content.addSubview(inner!)
                inner!.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
                inner!.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
                inner!.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
                inner!.bottomAnchor.constraint(equalTo: why.topAnchor, constant: -30).isActive = true
            }
            .store(in: &subs)
        
        timer
            .sink { _ in
                banner.tick()
            }
            .store(in: &subs)
        
        image.topAnchor.constraint(equalTo: content.topAnchor, constant: 100).isActive = true
        image.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        banner.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
        banner.centerYAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
        
        title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 80).isActive = true
        title.centerXAnchor.constraint(equalTo: content.centerXAnchor, constant: -22).isActive = true
        
        plus.centerYAnchor.constraint(equalTo: title.centerYAnchor).isActive = true
        plus.leftAnchor.constraint(equalTo: title.rightAnchor).isActive = true
        
        why.rightAnchor.constraint(equalTo: content.centerXAnchor, constant: -10).isActive = true
        why.centerYAnchor.constraint(equalTo: alternatives.centerYAnchor).isActive = true
        
        alternatives.leftAnchor.constraint(equalTo: content.centerXAnchor, constant: 10).isActive = true
        alternatives.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -50).isActive = true
        
        Task {
            await store.load()
        }
    }
}
