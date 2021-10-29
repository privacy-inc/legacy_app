import AppKit

extension Landing.Bookmarks {
    class Item: NSView {
        private(set) weak var title: Text!
        
        required init?(coder: NSCoder) { nil }
        init(icon: NSImageView) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let card = Card()
            card.addSubview(icon)
            addSubview(card)
            
            let title = Text(vibrancy: true)
            title.font = .preferredFont(forTextStyle: .footnote)
            title.alignment = .center
            title.maximumNumberOfLines = 2
            title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            self.title = title
            addSubview(title)
            
            card.topAnchor.constraint(equalTo: topAnchor).isActive = true
            card.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            card.rightAnchor.constraint(equalTo: icon.rightAnchor, constant: 15).isActive = true
            card.bottomAnchor.constraint(equalTo: icon.bottomAnchor, constant: 15).isActive = true

            icon.topAnchor.constraint(equalTo: card.topAnchor, constant: 15).isActive = true
            icon.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 15).isActive = true
            
            title.topAnchor.constraint(equalTo: card.bottomAnchor, constant: 10).isActive = true
            title.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor).isActive = true
            title.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor).isActive = true
        }
    }
}
