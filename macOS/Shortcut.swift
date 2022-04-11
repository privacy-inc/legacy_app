import AppKit

private let width = CGFloat(370)

final class Shortcut: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .init(origin: .zero, size: .init(width: width, height: 450)))
        wantsLayer = true
        
        let separator = CAShapeLayer()
        separator.fillColor = .clear
        separator.lineWidth = 1
        separator.strokeColor = NSColor.labelColor.withAlphaComponent(0.2).cgColor
        separator.path = .init(rect: .init(x: 0, y: 160, width: width, height: 0), transform: nil)
        layer!.addSublayer(separator)
        
        let background = NSVisualEffectView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.material = .hudWindow
        background.state = .active
        addSubview(background)
        
        let forget = Forget()
        forget.translatesAutoresizingMaskIntoConstraints = false
        addSubview(forget)
        
        let flip = Flip()
        flip.translatesAutoresizingMaskIntoConstraints = false
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.documentView = flip
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.drawsBackground = false
        scroll.scrollerInsets.top = 5
        scroll.scrollerInsets.bottom = 5
        scroll.automaticallyAdjustsContentInsets = false
        background.addSubview(scroll)
        
        let stack = NSStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        stack.spacing = 1
        flip.addSubview(stack)
        
        background.topAnchor.constraint(equalTo: topAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: forget.topAnchor, constant: 30).isActive = true
        
        forget.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20).isActive = true
        forget.leftAnchor.constraint(equalTo: background.leftAnchor).isActive = true
        forget.rightAnchor.constraint(equalTo: background.rightAnchor).isActive = true
        forget.heightAnchor.constraint(equalToConstant: 210).isActive = true
        
        scroll.topAnchor.constraint(equalTo: background.topAnchor, constant: 1).isActive = true
        scroll.leftAnchor.constraint(equalTo: background.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: background.rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: background.bottomAnchor).isActive = true
        
        flip.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        flip.leftAnchor.constraint(equalTo: scroll.leftAnchor).isActive = true
        flip.rightAnchor.constraint(equalTo: scroll.rightAnchor).isActive = true
        flip.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20).isActive = true
        
        stack.topAnchor.constraint(equalTo: flip.topAnchor, constant: 20).isActive = true
        stack.leftAnchor.constraint(equalTo: flip.leftAnchor, constant: 15).isActive = true
        stack.widthAnchor.constraint(equalToConstant: width - 30).isActive = true
        
        stack.setViews(NSApp
            .windows
            .compactMap {
                $0 as? Window
            }
            .flatMap { window in
                window
                    .status
                    .items
                    .value
                    .map {
                        (window: window, item: $0)
                    }
            }
            .map {
                Item(window: $0.window, item: $0.item, width: width)
            }, in: .center)
    }
}
