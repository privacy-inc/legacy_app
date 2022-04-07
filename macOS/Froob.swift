import AppKit
import Combine

final class Froob: NSWindow {
    private var sub: AnyCancellable?
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 460, height: 500),
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
        
        let image = Image(named: "Logo")
        image.imageScaling = .scaleNone
        content.addSubview(image)
        
        let title = Text(vibrancy: true)
        title.stringValue = "Privacy"
        title.font = NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title2).pointSize, weight: .regular)
        title.textColor = .labelColor
        content.addSubview(title)
        
        let plus = Image(icon: "plus")
        plus.symbolConfiguration = .init(pointSize: 28, weight: .ultraLight)
            .applying(.init(hierarchicalColor: .labelColor))
        content.addSubview(plus)
        
        let description = Text(vibrancy: true)
        description.attributedStringValue = .with(markdown: Copy.froob, attributes: [
            .font: NSFont.preferredFont(forTextStyle: .title3),
            .foregroundColor: NSColor.secondaryLabelColor])
        content.addSubview(description)
        
        let action = Action(title: "Learn more", color: .systemBlue, foreground: .white)
        content.addSubview(action)
        sub = action
            .click
            .sink { [weak self] in
//                NSApp.showPrivacyPlus()
                self?.close()
            }
        
        image.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        image.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
        title.centerXAnchor.constraint(equalTo: content.centerXAnchor, constant: -22).isActive = true
        
        plus.centerYAnchor.constraint(equalTo: title.centerYAnchor).isActive = true
        plus.leftAnchor.constraint(equalTo: title.rightAnchor).isActive = true
        
        description.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20).isActive = true
        description.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        description.widthAnchor.constraint(equalToConstant: 380).isActive = true
        
        action.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        action.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -40).isActive = true
    }
}
