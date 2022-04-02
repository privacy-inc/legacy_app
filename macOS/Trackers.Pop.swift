/*import AppKit

extension Trackers {
    final class Pop: NSPopover {
        required init?(coder: NSCoder) { nil }
        init(trackers: [String]) {
            super.init()
            behavior = .semitransient
            contentSize = .zero
            contentViewController = .init()
            
            let view = NSView(frame: .zero)
            contentViewController!.view = view
            
            let stack = NSStackView(views: trackers
                                        .map { item in
                                            let text = Text(vibrancy: true)
                                            text.stringValue = item
                                            text.font = .preferredFont(forTextStyle: .body)
                                            text.textColor = .secondaryLabelColor
                                            return text
                                        })
            stack.orientation = .vertical
            view.addSubview(stack)
            
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
            stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
            stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        }
    }
}
*/
