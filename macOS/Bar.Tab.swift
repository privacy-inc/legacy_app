import AppKit

extension Bar {
    final class Tab: NSView {
        var current = false {
            didSet {
                guard current != oldValue else { return }
                width.constant = current ? 300 : 150
            }
        }
        
        let status: Status.Item
        
        weak var right: Tab?
        weak var left: Tab? {
            didSet {
                left
                    .map {
                        align(left: $0.rightAnchor)
                    }
            }
        }
        
        private weak var width: NSLayoutConstraint!
        private weak var leftGuide: NSLayoutConstraint? {
            didSet {
                oldValue?.isActive = false
                leftGuide?.isActive = true
            }
        }
        
        required init?(coder: NSCoder) { nil }
        init(status: Status.Item) {
            self.status = status
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            layer = Layer()
            wantsLayer = true
            
            heightAnchor.constraint(equalToConstant: 28).isActive = true
            width = widthAnchor.constraint(equalToConstant: 0)
            width.isActive = true
        }
        
        func align(left: NSLayoutXAxisAnchor) {
            leftGuide = leftAnchor.constraint(equalTo: left, constant: 10)
        }

        override var allowsVibrancy: Bool {
            true
        }
    }
}
