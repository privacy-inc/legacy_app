import AppKit
import Combine
import Specs

final class About: NSWindow {
    private var subs = Set<AnyCancellable>()
    private let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 620, height: 600),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        animationBehavior = .alertPanel
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .hudWindow
        contentView = content
        center()
        
        let vibrant = Vibrant(layer: false)
        content.addSubview(vibrant)
        
        let image = NSImageView(image: .init(named: "Logo") ?? .init())
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        vibrant.addSubview(image)
        
        let banner = NSView()
        banner.layer = Layer()
        banner.wantsLayer = true
        banner.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(banner)
        
        let title = Text(vibrancy: true)
        title.stringValue = "Privacy"
        title.font = .preferredFont(forTextStyle: .title2)
        title.textColor = .labelColor
        content.addSubview(title)
        
        let subtitle = Text(vibrancy: true)
        subtitle.stringValue = "Support research and\ndevelopment of Privacy Browser"
        subtitle.textColor = .secondaryLabelColor
        subtitle.font = .preferredFont(forTextStyle: .callout)
        subtitle.alignment = .center
        content.addSubview(subtitle)
        
        let plus = NSImageView(image: .init(systemSymbolName: "plus", accessibilityDescription: nil) ?? .init())
        plus.translatesAutoresizingMaskIntoConstraints = false
        plus.symbolConfiguration = .init(pointSize: 18, weight: .regular)
        plus.contentTintColor = .labelColor
        content.addSubview(plus)
        
        let text = Text(vibrancy: true)
        text.attributedStringValue = .make(alignment: .center) {
            $0.append(.make("Privacy Browser", attributes: [
                .font: NSFont.systemFont(ofSize: 14, weight: .light),
                .foregroundColor: NSColor.labelColor]))
            $0.newLine()
            $0.append(.make(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "", attributes: [
                .font: NSFont.systemFont(ofSize: 10, weight: .regular),
                .foregroundColor: NSColor.tertiaryLabelColor]))
        }
        content.addSubview(text)
        
        let location = Text(vibrancy: true)
        location.stringValue = "From Berlin with"
        location.font = .systemFont(ofSize: 11, weight: .regular)
        location.textColor = .tertiaryLabelColor
        content.addSubview(location)
        
        let heart = NSImageView(image: .init(systemSymbolName: "heart.fill", accessibilityDescription: nil) ?? .init())
        heart.translatesAutoresizingMaskIntoConstraints = false
        heart.symbolConfiguration = .init(pointSize: 12, weight: .regular)
        heart.contentTintColor = .systemPink
        content.addSubview(heart)
        
        let stack = NSStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        stack.spacing = 5
        content.addSubview(stack)

        timer
            .sink { _ in
                banner.layer!.setNeedsDisplay()
            }
            .store(in: &subs)
        
        store
            .status
            .sink { [weak self] status in
                stack
                    .views
                    .forEach {
                        stack.removeView($0)
                    }
                
                if Defaults.isPremium {
                    let check = NSImageView(image: .init(systemSymbolName: "checkmark.circle.fill", accessibilityDescription: nil) ?? .init())
                    check.symbolConfiguration = .init(pointSize: 40, weight: .bold)
                        .applying(.init(hierarchicalColor: .init(named: "Shades")!))
                    
                    let text = Text(vibrancy: true)
                    text.stringValue = "We received your support\nThank you!"
                    text.alignment = .center
                    text.textColor = .secondaryLabelColor
                    text.font = .preferredFont(forTextStyle: .callout)
                    
                    stack.setViews([check, text], in: .center)
                    stack.setCustomSpacing(15, after: check)
                } else {
                    switch status {
                    case .loading:
                        let image = NSImageView(image: .init(systemSymbolName: "hourglass", accessibilityDescription: nil) ?? .init())
                        image.symbolConfiguration = .init(pointSize: 40, weight: .ultraLight)
                            .applying(.init(hierarchicalColor: .init(named: "Dawn")!))
                        stack.setViews([image], in: .center)
                    case let .error(error):
                        let text = Text(vibrancy: true)
                        text.font = .preferredFont(forTextStyle: .callout)
                        text.alignment = .center
                        text.textColor = .secondaryLabelColor
                        text.stringValue = error
                        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                        text.widthAnchor.constraint(equalToConstant: 300).isActive = true
                        stack.setViews([text], in: .center)
                    case let .products(products):
                        guard let product = products.first else { return }
                        
                        let price = Text(vibrancy: true)
                        price.stringValue = product.displayPrice
                        price.font = .preferredFont(forTextStyle: .body)
                        price.textColor = .labelColor
                        
                        let purchase = Control.Capsule("Purchase", color: .systemBlue, foreground: .white)
                        self?.add(purchase
                            .click
                            .sink {
                                Task {
                                    await store.purchase(product)
                                }
                            })
                        
                        let restore = Control.Title("Restore Purchases", color: .secondaryLabelColor, layer: false)
                        self?.add(restore
                            .click
                            .sink {
                                Task {
                                    await store.restore()
                                }
                            })
                        
                        let learn = Control.Title("Learn more", color: .systemMint, layer: false)
                        self?.add(learn
                            .click
                            .sink {
                                (NSApp as! App).showLearn(with: .purchases)
                            })
                        
                        let horizontal = NSStackView(views: [restore, learn])
                        horizontal.distribution = .fillEqually
                        
                        stack.setViews([price, purchase, horizontal], in: .center)
                    }
                }
            }
            .store(in: &subs)
        
        vibrant.topAnchor.constraint(equalTo: image.topAnchor).isActive = true
        vibrant.bottomAnchor.constraint(equalTo: image.bottomAnchor).isActive = true
        vibrant.leftAnchor.constraint(equalTo: image.leftAnchor).isActive = true
        vibrant.rightAnchor.constraint(equalTo: image.rightAnchor).isActive = true
        
        image.centerXAnchor.constraint(equalTo: banner.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: banner.centerYAnchor).isActive = true
        
        banner.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        banner.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        banner.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        banner.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        title.centerXAnchor.constraint(equalTo: content.centerXAnchor, constant: -15).isActive = true
        title.topAnchor.constraint(equalTo: banner.bottomAnchor).isActive = true
        
        plus.centerYAnchor.constraint(equalTo: title.centerYAnchor).isActive = true
        plus.leftAnchor.constraint(equalTo: title.rightAnchor, constant: 2).isActive = true
        
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 3).isActive = true
        subtitle.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        stack.topAnchor.constraint(equalTo: subtitle.bottomAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: text.topAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        
        text.bottomAnchor.constraint(equalTo: location.topAnchor, constant: -2).isActive = true
        text.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        heart.centerYAnchor.constraint(equalTo: location.centerYAnchor).isActive = true
        heart.leftAnchor.constraint(equalTo: location.rightAnchor, constant: 2).isActive = true
        
        location.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -40).isActive = true
        location.centerXAnchor.constraint(equalTo: content.centerXAnchor, constant: -10).isActive = true
        
        Task {
            await store.load()
        }
    }
    
    private func add(_ cancellable: AnyCancellable) {
        subs.insert(cancellable)
    }
}
