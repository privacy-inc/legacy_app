import AppKit
import Specs

extension Landing.Bookmarks {
    final class Item: NSView {
        required init?(coder: NSCoder) { nil }
        init(bookmark: Website) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let title = Text(vibrancy: true)
            title.stringValue = bookmark.title
            title.font = .preferredFont(forTextStyle: .caption1)
            title.textColor = .secondaryLabelColor
            title.alignment = .center
            title.maximumNumberOfLines = 2
            title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(title)
            
            heightAnchor.constraint(equalToConstant: 100).isActive = true

            title.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
            title.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor).isActive = true
            title.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor).isActive = true
            title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            title.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
        }
    }
}
