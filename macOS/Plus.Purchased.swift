import AppKit

extension Plus {
    final class Purchased: NSView {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            
            let check = Image(icon: "checkmark.circle.fill", vibrancy: false)
            check.symbolConfiguration = .init(pointSize: 30, weight: .regular)
                .applying(.init(hierarchicalColor: .init(named: "Shades")!))
            addSubview(check)
            
            let text = Text(vibrancy: true)
            text.attributedStringValue = .init(message.with(alignment: .center))
            text.font = .preferredFont(forTextStyle: .body)
            addSubview(text)
            
            check.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
            check.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            text.topAnchor.constraint(equalTo: check.bottomAnchor, constant: 15).isActive = true
        }
        
        private var message: AttributedString {
            .init("We received your support\n", attributes: .init([
                .foregroundColor: NSColor.secondaryLabelColor]))
            + .init("Thank you!", attributes: .init([
                .foregroundColor: NSColor.labelColor]))
        }
    }
}
