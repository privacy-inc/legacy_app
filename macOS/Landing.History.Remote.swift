import AppKit
import Specs

extension Landing.History {
    final class Remote: Item {
        required init?(coder: NSCoder) { nil }
        init(item: Specs.History, remote: Access.Remote) {
            super.init()
            let icon = Icon()
            icon.icon(icon: item.website.access.icon)
            addSubview(icon)
            
            let title = Text(vibrancy: true)
            title.attributedStringValue = .make(lineBreak: .byTruncatingMiddle) {
                $0.append(.make(item.website.title, attributes: [
                    .foregroundColor: NSColor.labelColor]))
                $0.append(.make(" " + remote.domain.minimal, attributes: [
                    .foregroundColor: NSColor.tertiaryLabelColor]))
            }
            title.font = .preferredFont(forTextStyle: .body)
            title.maximumNumberOfLines = 1
            title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(title)
            
            bottomAnchor.constraint(equalTo: icon.bottomAnchor, constant: 10).isActive = true

            icon.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
            icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
            
            title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            title.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 10).isActive = true
            title.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -16).isActive = true
        }
    }
}
