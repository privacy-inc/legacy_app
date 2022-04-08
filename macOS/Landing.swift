import AppKit
import Combine
import Specs

final class Landing: NSView {
    private var subs = Set<AnyCancellable>()

    required init?(coder: NSCoder) { nil }
    init(status: Status) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let list = List(status: status, width: 426)
        addSubview(list)
        
        let configure = Control.Symbol("slider.vertical.3", point: 18, size: 40)
        configure
            .click
            .sink {
                (NSApp as! App).showPreferencesWindow(nil)
            }
            .store(in: &subs)
        
        let forget = Control.Symbol("flame", point: 18, size: 40)
        forget
            .click
            .sink {
                NSPopover().show(Forget(), from: forget, edge: .minY)
            }
            .store(in: &subs)
        
        let stack = NSStackView(views: [forget, configure])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        addSubview(stack)
        
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        list.topAnchor.constraint(equalTo: topAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        list.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        list.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    override func mouseDown(with: NSEvent) {
        super.mouseDown(with: with)
        if with.clickCount == 1 {
            window?.makeFirstResponder(self)
        }
    }
}
