import AppKit
import Specs

extension Landing.History {
    final class Remote: NSView {
        private(set) weak var title: Text!
        
        required init?(coder: NSCoder) { nil }
        init(item: History) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let card = NSView()
            card.translatesAutoresizingMaskIntoConstraints = false
            card.layer = Layer()
            card.wantsLayer = true
            card.layer!.cornerCurve = .continuous
            card.layer!.cornerRadius = 14
            card.layer!.borderColor = NSColor.quaternaryLabelColor.cgColor
            card.layer!.borderWidth = 1
            card.addSubview(icon)
            addSubview(card)
            
            let title = Text(vibrancy: true)
            title.font = .preferredFont(forTextStyle: .caption1)
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
