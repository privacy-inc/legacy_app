import AppKit

class Info: NSWindow {
    init(title: String, copy: String) {
        super.init(contentRect: .init(x: 0, y: 0, width: 500, height: 700),
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
        
        let text = Text(vibrancy: true)
        text.maximumNumberOfLines = 0
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        text.attributedStringValue = .init(
            .init(title + "\n\n", attributes: .init([.font: NSFont.preferredFont(forTextStyle: .title1),
                                           .foregroundColor: NSColor.labelColor]))
            + .with(markdown: copy, attributes: .init([
                .font: NSFont.preferredFont(forTextStyle: .title3),
                .foregroundColor: NSColor.secondaryLabelColor])))
        content.addSubview(text)
        
        text.topAnchor.constraint(equalTo: content.topAnchor, constant: 70).isActive = true
        text.leftAnchor.constraint(equalTo: content.leftAnchor, constant: 50).isActive = true
        text.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -50).isActive = true
        text.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -50).isActive = true
        text.widthAnchor.constraint(equalToConstant: 500).isActive = true
    }
    
    @objc func triggerCloseTab() {
        close()
    }
}
