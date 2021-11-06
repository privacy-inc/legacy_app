import AppKit
import Combine

final class Pop: NSPopover {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(title: String, copy: String) {
        super.init()
        behavior = .semitransient
        contentSize = .zero
        contentViewController = .init()
        
        let view = NSView(frame: .zero)
        contentViewController!.view = view
        
        var copy = (try? AttributedString(markdown: copy, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace))) ?? .init(copy)
        copy.setAttributes(.init([
            .font: NSFont.preferredFont(forTextStyle: .body),
            .foregroundColor: NSColor.labelColor]))
        
        let text = Text(vibrancy: true)
        text.maximumNumberOfLines = 0
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        text.attributedStringValue = .init(
            .init(title + "\n\n", attributes: .init([.font: NSFont.preferredFont(forTextStyle: .title2),
                                           .foregroundColor: NSColor.tertiaryLabelColor]))
            + copy)
        view.addSubview(text)
        
        text.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        text.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        text.widthAnchor.constraint(equalToConstant: 380).isActive = true
        text.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        text.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
    }
}
