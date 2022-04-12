import AppKit
import Combine

final class About: NSWindow {
    private var subs = Set<AnyCancellable>()
    private let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 380, height: 480),
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
        
        let text = Text(vibrancy: true)
        text.attributedStringValue = .make(alignment: .center) {
            $0.append(.make("Privacy Browser", attributes: [
                .font: NSFont.systemFont(ofSize: 18, weight: .light),
                .foregroundColor: NSColor.labelColor]))
            $0.newLine()
            $0.append(.make(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "", attributes: [
                .font: NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .regular),
                .foregroundColor: NSColor.secondaryLabelColor]))
            $0.newLine()
            $0.append(.make("From Berlin with ", attributes: [
                .font: NSFont.systemFont(ofSize: 12, weight: .regular),
                .foregroundColor: NSColor.tertiaryLabelColor]))
            $0.append(.make("􀊵", attributes: [
                .font: NSFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: NSColor.systemPink]))
        }
        content.addSubview(text)

        timer
            .sink { _ in
                banner.layer!.setNeedsDisplay()
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
        banner.heightAnchor.constraint(equalToConstant: 220).isActive = true
        
        text.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -40).isActive = true
        text.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
    }
}
