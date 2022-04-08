import AppKit

final class Tab: NSView, NSMenuDelegate {
    let item: UUID
    private let status: Status
    
    var current: Bool {
        didSet {
            guard current != oldValue else { return }
            load()
        }
    }
    
    weak var right: Tab?
    weak var left: Tab? {
        didSet {
            left
                .map {
                    align(after: $0.rightAnchor)
                }
        }
    }
    
    private weak var leftGuide: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
            leftGuide?.isActive = true
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init(status: Status, item: UUID, current: Bool) {
        self.status = status
        self.item = item
        self.current = current
        
        super.init(frame: .zero)
        menu = NSMenu()
        menu!.delegate = self
        menu!.autoenablesItems = false
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalToConstant: Bar.height).isActive = true
        load()
    }
    
    func align(after: NSLayoutXAxisAnchor) {
        leftGuide = leftAnchor.constraint(equalTo: after, constant: 10)
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
    
    private func load() {
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
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
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
