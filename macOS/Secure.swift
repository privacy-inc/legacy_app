import AppKit

final class Secure: NSView {
    required init?(coder: NSCoder) { nil }
    init(status: Status, id: UUID) {
        super.init(frame: .init(origin: .zero, size: .init(width: 320, height: 160)))
        
        let icon = NSImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.symbolConfiguration = .init(pointSize: 40, weight: .thin)
            .applying(.init(hierarchicalColor: .tertiaryLabelColor))
        addSubview(icon)
        
        let message = Text(vibrancy: false)
        message.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(message)
        
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 25).isActive = true
        
        message.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 20).isActive = true
        message.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        message.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -30).isActive = true
        
        if case let .web(web) = status.flow(of: id),
           let domain = web.url?.absoluteString.domain {
            icon.image = .init(systemSymbolName: web.hasOnlySecureContent
                               ? "lock.circle.fill"
                               : "exclamationmark.triangle.fill",
                               accessibilityDescription: nil)
            
            message.attributedStringValue = .make {
                $0.append(.make(web.hasOnlySecureContent
                                ? "Using an encrypted connnection to "
                                : "Using an insecure connnection to ",
                                attributes: [
                                    .font: NSFont.preferredFont(forTextStyle: .body),
                    .foregroundColor: NSColor.labelColor]))
                $0.append(.make(domain, attributes: [
                    .font: NSFontManager.shared.font(withFamily: NSFont.preferredFont(forTextStyle: .body).familyName ?? "",
                                                     traits: [.italicFontMask],
                                                     weight: 5,
                                                     size: NSFont.preferredFont(forTextStyle: .body).pointSize)
                    ?? NSFont.preferredFont(forTextStyle: .body),
                    .foregroundColor: NSColor.secondaryLabelColor]))
                $0.newLine()
                $0.newLine()
                $0.append(.make(web.hasOnlySecureContent
                                ? "Encryption with a digital certificate keeps information private as it's sent to or from this website."
                                : "Information is not private and might be compromised as it's sent to or from this website.", attributes: [
                    .font: NSFont.preferredFont(forTextStyle: .footnote),
                    .foregroundColor: NSColor.secondaryLabelColor]))
            }
        }
    }

    override var allowsVibrancy: Bool {
        true
    }
}
