/*import AppKit
import Specs

extension Landing.Edit {
    final class Item: NSView {
        private let card: Specs.Card
        
        required init?(coder: NSCoder) { nil }
        init(card: Specs.Card) {
            self.card = card
            
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let control = NSSwitch()
            control.target = self
            control.action = #selector(action)
            control.translatesAutoresizingMaskIntoConstraints = false
            control.state = card.state ? .on : .off
            addSubview(control)
            
            let title = Text(vibrancy: true)
            title.stringValue = card.id.title
            title.font = .preferredFont(forTextStyle: .body)
            title.textColor = .secondaryLabelColor
            addSubview(title)
            
            let icon = Image(icon: card.id.symbol)
            icon.symbolConfiguration = .init(textStyle: .title3)
                .applying(.init(hierarchicalColor: .secondaryLabelColor))
            addSubview(icon)
            
            heightAnchor.constraint(equalToConstant: 40).isActive = true
            rightAnchor.constraint(equalTo: icon.rightAnchor).isActive = true
            
            control.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            control.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            title.leftAnchor.constraint(equalTo: control.rightAnchor, constant: 10).isActive = true
            title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            icon.leftAnchor.constraint(equalTo: title.rightAnchor, constant: 12).isActive = true
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
        
        @objc private func action(_ control: NSSwitch) {
            Task {
                await cloud.turn(card: card.id, state: control.state == .on)
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
*/
