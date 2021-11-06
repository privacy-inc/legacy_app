import AppKit

final class About: NSWindow {
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 320, height: 360),
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
        
        let image = Image(named: "Logo", vibrancy: false)
        image.imageScaling = .scaleNone
        content.addSubview(image)
        
        let name = Text(vibrancy: true)
        name.stringValue = "Privacy"
        name.font = .preferredFont(forTextStyle: .largeTitle)
        name.textColor = .labelColor
        content.addSubview(name)
        
        let version = Text(vibrancy: true)
        version.stringValue = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        version.font = .monospacedSystemFont(ofSize: 18, weight: .light)
        version.textColor = .secondaryLabelColor
        content.addSubview(version)
        
        let disclaimer = Text(vibrancy: true)
        disclaimer.stringValue = "From Berlin with"
        disclaimer.font = .preferredFont(forTextStyle: .callout)
        disclaimer.textColor = .tertiaryLabelColor
        content.addSubview(disclaimer)
        
        let heart = Image(icon: "heart", vibrancy: false)
        heart.symbolConfiguration = .init(textStyle: .body)
            .applying(.init(paletteColors: [.systemPink]))
        content.addSubview(heart)
        
        image.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        image.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        name.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
        name.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        version.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5).isActive = true
        version.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        disclaimer.topAnchor.constraint(equalTo: content.bottomAnchor, constant: -60).isActive = true
        disclaimer.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        heart.centerYAnchor.constraint(equalTo: disclaimer.centerYAnchor).isActive = true
        heart.leftAnchor.constraint(equalTo: disclaimer.rightAnchor).isActive = true
    }
    
    @objc func triggerCloseTab() {
        close()
    }
}
