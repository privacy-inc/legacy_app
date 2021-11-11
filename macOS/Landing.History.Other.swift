import AppKit
import Specs

extension Landing.History {
    final class Other: Item {
        required init?(coder: NSCoder) { nil }
        init(item: Specs.History) {
            super.init()
            let title = Text(vibrancy: true)
            title.stringValue = item.website.access.value
            title.textColor = .tertiaryLabelColor
            title.font = .preferredFont(forTextStyle: .body)
            title.maximumNumberOfLines = 1
            title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(title)
            
            bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: 16).isActive = true
            
            title.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
            title.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -16).isActive = true
        }
    }
}
