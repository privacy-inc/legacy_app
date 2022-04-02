/*import AppKit
import Specs

extension Landing {
    final class Edit: NSPopover {
        private weak var stack: NSStackView!
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            behavior = .semitransient
            contentSize = .zero
            contentViewController = .init()
            
            let view = NSView(frame: .zero)
            contentViewController!.view = view
            
            let stack = NSStackView(views: [])
            stack.orientation = .vertical
            stack.alignment = .leading
            self.stack = stack
            view.addSubview(stack)
            
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
            stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 45).isActive = true
            stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -45).isActive = true
            
            Task {
                await order(cards: cloud.model.cards)
            }
        }
        
        @MainActor private func order(cards: [Specs.Card]) {
            let title = Text(vibrancy: true)
            title.stringValue = "Configure"
            title.font = .preferredFont(forTextStyle: .title3)
            title.textColor = .secondaryLabelColor
            
            stack.setViews([title] + cards
                            .map {
                                Item(card: $0)
                            }, in: .top)
        }
    }
}
*/
