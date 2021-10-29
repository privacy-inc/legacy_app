import AppKit
import Specs

extension Landing.History {
    final class Other: NSView {
        required init?(coder: NSCoder) { nil }
        init(item: History) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let title = Text(vibrancy: true)
            title.stringValue = item.website.access.value
            title.textColor = .tertiaryLabelColor
            title.font = .preferredFont(forTextStyle: .body)
            title.maximumNumberOfLines = 1
            title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(title)
            
            bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: 15).isActive = true
            
            title.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
            title.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            title.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -10).isActive = true
        }
    }
}
