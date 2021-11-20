import AppKit

final class Pop: NSPopover {
    required init?(coder: NSCoder) { nil }
    init(title: String, copy: String) {
        super.init()
        behavior = .semitransient
        contentSize = .zero
        contentViewController = .init()
        
        let view = NSView(frame: .zero)
        contentViewController!.view = view
        
        let text = Text(vibrancy: true)
        text.maximumNumberOfLines = 0
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        text.attributedStringValue = .make {
            $0.append(.make(title, attributes: [
                .font: NSFont.preferredFont(forTextStyle: .title2),
                .foregroundColor: NSColor.tertiaryLabelColor]))
            $0.newLine()
            $0.newLine()
            $0.append(.with(markdown: copy, attributes: [
                    .font: NSFont.preferredFont(forTextStyle: .body),
                    .foregroundColor: NSColor.secondaryLabelColor]))
        }
        view.addSubview(text)
        
        text.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        text.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        text.widthAnchor.constraint(equalToConstant: 380).isActive = true
        text.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        text.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
    }
}
