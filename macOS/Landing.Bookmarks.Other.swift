import AppKit

extension Landing.Bookmarks {
    final class Other: Item {
        required init?(coder: NSCoder) { nil }
        init(title: String) {
            let icon = Image(icon: "globe")
            icon.symbolConfiguration = .init(textStyle: .largeTitle, scale: .large)
                .applying(.init(hierarchicalColor: .secondaryLabelColor))
            
            super.init(icon: icon)
            self.title.stringValue = title
            self.title.textColor = .tertiaryLabelColor
            
            icon.widthAnchor.constraint(equalToConstant: 32).isActive = true
            icon.heightAnchor.constraint(equalTo: icon.widthAnchor).isActive = true
        }
    }
}
