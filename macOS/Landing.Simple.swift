/*import AppKit

extension Landing {
    class Simple: Section {
        private(set) weak var icon: Image!
        private(set) weak var first: Text!
        private(set) weak var second: Text!
        private(set) weak var card: Card!
        
        required init?(coder: NSCoder) { nil }
        init(title: String, icon: String) {
            super.init()
            header.stringValue = title
            
            let card = Card()
            self.card = card
            addSubview(card)
            
            let icon = Image(icon: icon)
            icon.symbolConfiguration = .init(textStyle: .largeTitle)
            self.icon = icon
            card.addSubview(icon)
            
            let first = Text(vibrancy: true)
            first.textColor = .secondaryLabelColor
            self.first = first
            addSubview(first)
            
            let second = Text(vibrancy: true)
            second.textColor = .tertiaryLabelColor
            second.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular)
            self.second = second
            addSubview(second)
            
            bottomAnchor.constraint(equalTo: card.bottomAnchor).isActive = true
            
            card.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10).isActive = true
            card.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            card.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            card.heightAnchor.constraint(equalToConstant: 62).isActive = true
            
            icon.centerYAnchor.constraint(equalTo: card.centerYAnchor).isActive = true
            icon.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 20).isActive = true
            
            first.centerYAnchor.constraint(equalTo: card.centerYAnchor).isActive = true
            first.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 10).isActive = true
            
            second.centerYAnchor.constraint(equalTo: card.centerYAnchor).isActive = true
            second.leftAnchor.constraint(equalTo: first.rightAnchor).isActive = true
        }
    }
}
*/
