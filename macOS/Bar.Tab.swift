import AppKit

extension Bar {
    final class Tab: NSView {
        var current = false {
            didSet {
                guard current != oldValue else { return }
                subviews
                    .forEach {
                        $0.removeFromSuperview()
                    }
                
                let view: NSView
                if current {
                    view = On(status: status, item: item)
                } else {
                    view = Off(status: status, item: item)
                }
                addSubview(view)
                
                rightGuide = rightAnchor.constraint(equalTo: view.rightAnchor)
                
                view.topAnchor.constraint(equalTo: topAnchor).isActive = true
                view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
                view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            }
        }
        
        let item: UUID
        
        weak var right: Tab?
        weak var left: Tab? {
            didSet {
                left
                    .map {
                        align(left: $0.rightAnchor)
                    }
            }
        }
        
        private weak var rightGuide: NSLayoutConstraint? {
            didSet {
                oldValue?.isActive = false
                rightGuide?.isActive = true
            }
        }
        
        private weak var leftGuide: NSLayoutConstraint? {
            didSet {
                oldValue?.isActive = false
                leftGuide?.isActive = true
            }
        }
        
        private let status: Status
        
        required init?(coder: NSCoder) { nil }
        init(status: Status, item: UUID) {
            self.status = status
            self.item = item
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            layer = Layer()
            wantsLayer = true
            
            heightAnchor.constraint(equalToConstant: 28).isActive = true
        }
        
        func align(left: NSLayoutXAxisAnchor) {
            leftGuide = leftAnchor.constraint(equalTo: left, constant: 10)
        }
    }
}
