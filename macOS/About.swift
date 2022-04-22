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
        
        let gradient = CAGradientLayer()
        gradient.startPoint = .init(x: 0.5, y: 1)
        gradient.endPoint = .init(x: 0.5, y: 0)
        gradient.locations = [0, 0.5, 1]
        gradient.colors = [CGColor.white, CGColor(gray: 1, alpha: 0.2), CGColor(gray: 1, alpha: 0.1)]
        gradient.frame = .init(origin: .zero, size: frame.size)
        
        let banner = NSView()
        banner.layer = Layer()
        banner.wantsLayer = true
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.layer!.mask = gradient
        content.addSubview(banner)
        
        let text = Text(vibrancy: true)
        text.attributedStringValue = .make(alignment: .center) {
            $0.append(.make("Privacy Browser ", attributes: [
                .font: NSFont.systemFont(ofSize: 14, weight: .light),
                .foregroundColor: NSColor.labelColor]))
            $0.append(.make(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "", attributes: [
                .font: NSFont.systemFont(ofSize: 10, weight: .regular),
                .foregroundColor: NSColor.secondaryLabelColor]))
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
        stack.spacing = 10
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
                    check.symbolConfiguration = .init(pointSize: 35, weight: .bold)
                        .applying(.init(paletteColors: [.white, .systemBlue]))
                    
                    let text = Text(vibrancy: true)
                    text.stringValue = "We received your support\nThank you!"
                    text.alignment = .center
                    text.textColor = .labelColor
                    text.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize, weight: .medium)
                    
                    stack.setViews([check, text], in: .center)
                } else {
                    switch status {
                    case .loading:
                        let image = NSImageView(image: .init(systemSymbolName: "hourglass", accessibilityDescription: nil) ?? .init())
                        image.symbolConfiguration = .init(pointSize: 30, weight: .ultraLight)
                            .applying(.init(hierarchicalColor: .init(named: "Dawn")!))
                        stack.setViews([image], in: .center)
                    case let .error(error):
                        let text = Text(vibrancy: true)
                        text.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .medium)
                        text.alignment = .center
                        text.textColor = .labelColor
                        text.stringValue = error
                        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                        text.widthAnchor.constraint(equalToConstant: 300).isActive = true
                        stack.setViews([text], in: .center)
                    case let .products(products):
                        guard let product = products.first else { return }
                        
                        let title = Text(vibrancy: true)
                        title.stringValue = "Privacy"
                        title.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .medium)
                        title.textColor = .secondaryLabelColor
                        
                        let plus = NSImageView(image: .init(systemSymbolName: "plus", accessibilityDescription: nil) ?? .init())
                        plus.symbolConfiguration = .init(pointSize: 16, weight: .light)
                        plus.contentTintColor = .secondaryLabelColor
                        
                        let horizontal1 = NSStackView(views: [title, plus])
                        horizontal1.spacing = 2
                        
                        let subtitle = Text(vibrancy: true)
                        subtitle.stringValue = "Sponsor research\nand development of\nPrivacy Browser."
                        subtitle.textColor = .labelColor
                        subtitle.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .medium)
                        subtitle.alignment = .center
                        
                        let price = Text(vibrancy: true)
                        price.stringValue = "1 time only " + product.displayPrice + " purchase."
                        price.font = .preferredFont(forTextStyle: .body)
                        price.textColor = .labelColor
                        
                        let purchase = Control.Prominent("Support Now")
                        purchase.widthAnchor.constraint(equalToConstant: 260).isActive = true
                        self?.add(purchase
                            .click
                            .sink {
                                (NSApp as! App).froob.value = false
                                
                                Task {
                                    await store.purchase(product)
                                }
                            })
                        
                        let restore = Control.Title("Restore Purchases", color: .secondaryLabelColor, layer: false)
                        self?.add(restore
                            .click
                            .sink {
                                (NSApp as! App).froob.value = false
                                
                                Task {
                                    await store.restore()
                                }
                            })
                        
                        let learn = Control.Title("Learn More", color: .systemBlue, layer: false)
                        self?.add(learn
                            .click
                            .sink {
                                (NSApp as! App).showLearn(with: .purchases)
                            })
                        
                        let horizontal2 = NSStackView(views: [restore, learn])
                        horizontal2.distribution = .fill
                        
                        stack.setViews([horizontal1, subtitle, purchase, price, horizontal2], in: .center)
                        stack.setCustomSpacing(14, after: horizontal1)
                        stack.setCustomSpacing(50, after: price)
                    }
                }
            }
            .store(in: &subs)
        
        vibrant.topAnchor.constraint(equalTo: image.topAnchor).isActive = true
        vibrant.bottomAnchor.constraint(equalTo: image.bottomAnchor).isActive = true
        vibrant.leftAnchor.constraint(equalTo: image.leftAnchor).isActive = true
        vibrant.rightAnchor.constraint(equalTo: image.rightAnchor).isActive = true
        
        image.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: content.topAnchor, constant: 150).isActive = true
        
        banner.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        banner.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        banner.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        banner.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        
        stack.topAnchor.constraint(equalTo: image.bottomAnchor).isActive = true
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
