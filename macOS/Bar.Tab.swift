import AppKit

extension Bar {
    final class Tab: NSView, NSMenuDelegate {
        let item: UUID
        private let status: Status
        
        var current = false {
            didSet {
                guard subviews.isEmpty || current != oldValue else { return }
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
        
        required init?(coder: NSCoder) { nil }
        init(status: Status, item: UUID) {
            self.status = status
            self.item = item
            super.init(frame: .zero)
            menu = NSMenu()
            menu!.delegate = self
            menu!.autoenablesItems = false
            translatesAutoresizingMaskIntoConstraints = false
            
            heightAnchor.constraint(equalToConstant: Bar.height).isActive = true
        }
        
        func align(left: NSLayoutXAxisAnchor) {
            leftGuide = leftAnchor.constraint(equalTo: left, constant: 10)
        }
        
        func menuNeedsUpdate(_ menu: NSMenu) {
            menu.items = [
                .child("Close Tab", #selector(closeTab)) {
                    $0.target = self
                    $0.isEnabled = status.items.value.count > 1
                },
                .child("Close Other Tabs", #selector(closeOthers)) {
                    $0.target = self
                    $0.isEnabled = status.items.value.count > 1
                },
                .separator(),
                .child("Move Tab to New Window", #selector(moveToWindow)) {
                    $0.target = self
                    $0.isEnabled = status.items.value.count > 1
                }]
        }
        
        @objc private func closeTab() {
            status.close(id: item)
        }
        
        @objc private func closeOthers() {
            status.close(except: item)
        }
        
        @objc private func moveToWindow() {
            status.toNewWindow(id: item)
        }
    }
}
