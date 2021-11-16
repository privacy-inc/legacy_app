import AppKit

extension Plus {
    final class Banner: NSView {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            layer = Layer()
            wantsLayer = true
            
            widthAnchor.constraint(equalToConstant: 250).isActive = true
            heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        }
        
        func tick() {
            
        }
        
        override func hitTest(_: NSPoint) -> NSView? {
            nil
        }
    }
}
