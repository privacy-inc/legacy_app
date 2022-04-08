import AppKit
import Combine

final class Bar: NSVisualEffectView {
    static let height = CGFloat(28)
    private var subs = Set<AnyCancellable>()
    private let status: Status
    
    required init?(coder: NSCoder) { nil }
    init(status: Status) {
        self.status = status
        
        super.init(frame: .zero)
        state = .active
        material = .menu
        
        var tabs = [Tab]()
        
        let content = NSView()
        content.translatesAutoresizingMaskIntoConstraints = false
        addSubview(content)
        
        let plus = Control.Symbol("plus", point: 16, size: Self.height)
        plus.toolTip = "New tab"
        plus
            .click
            .sink {
                status.addTab()
            }
            .store(in: &subs)
        addSubview(plus)
        
        status
            .items
            .removeDuplicates()
            .sink {
                var items = $0
                tabs = tabs
                    .filter { tab in
                        guard items.remove(where: { $0.id == tab.item }) == nil else { return true }
                        tab.left?.right = tab.right
                        tab.right?.left = tab.left
                        tab.removeFromSuperview()
                        return false
                    }
                
                items
                    .forEach {
                        let tab = Tab(status: status, item: $0.id, current: $0.id == status.current.value)
                        content.addSubview(tab)
                        
                        tabs.last?.right = tab
                        tab.left = tabs.last
                        tab.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 1).isActive = true
                        
                        tabs.append(tab)
                    }
                
                tabs.first?.align(after: content.leftAnchor)
            }
            .store(in: &subs)
        
        status
            .current
            .sink { current in
                tabs
                    .forEach { tab in
                        tab.current = tab.item == current
                    }
            }
            .store(in: &subs)
        
        status
            .current
            .combineLatest(status
                .items) { _, _ in
                    Date()
                }
                .removeDuplicates {
                    $1.timeIntervalSince1970 - $0.timeIntervalSince1970 < 1
                }
                .sink { [weak self] _ in
                    NSAnimationContext
                        .runAnimationGroup {
                            $0.allowsImplicitAnimation = true
                            $0.duration = 0.3
                            self?.layoutSubtreeIfNeeded()
                        }
                }
                .store(in: &subs)
        
        plus.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        plus.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
        
        content.topAnchor.constraint(equalTo: topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        content.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: plus.leftAnchor).isActive = true
    }
    
    override var frame: NSRect {
        didSet {
            let delta = (frame.width - 500) / 3
            status.width.send((on: max(min(450, 240 + delta), 240),  off: max(min(160, 50 + delta), 50)))
        }
    }
}
