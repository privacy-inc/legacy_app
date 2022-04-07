import AppKit

final class Message: NSView {
    required init?(coder: NSCoder) { nil }
    init(url: URL?, title: String, icon: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        alphaValue = 0
        
        let icon = Image(icon: icon)
        icon.symbolConfiguration = .init(pointSize: 45, weight: .ultraLight)
            .applying(.init(hierarchicalColor: .secondaryLabelColor))
        addSubview(icon)
        
        let text = Text(vibrancy: true)
        text.attributedStringValue = .make {
            if let url = url?.absoluteString {
                $0.append(.make(url, attributes: [
                    .font: NSFont.preferredFont(forTextStyle: .body),
                    .foregroundColor: NSColor.tertiaryLabelColor]))
            }
            
            $0.newLine()
            
            $0.append(.make(title, attributes: [
                .font: NSFont.preferredFont(forTextStyle: .body),
                .foregroundColor: NSColor.secondaryLabelColor]))
        }
        text.maximumNumberOfLines = 0
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(text)
        
        icon.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        text.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
        text.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 5).isActive = true
        text.topAnchor.constraint(greaterThanOrEqualTo: icon.topAnchor).isActive = true
        text.bottomAnchor.constraint(lessThanOrEqualTo: icon.bottomAnchor).isActive = true
        text.widthAnchor.constraint(lessThanOrEqualToConstant: 260).isActive = true
        
        NSAnimationContext
            .runAnimationGroup {
                $0.duration = 0.4
                $0.allowsImplicitAnimation = true
                $0.timingFunction = .init(name: .easeInEaseOut)
                animator().alphaValue = 1
            }
    }
}
