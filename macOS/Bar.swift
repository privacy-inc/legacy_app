import AppKit
import Combine

final class Bar: NSVisualEffectView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(status: Status) {
        super.init(frame: .zero)
        state = .active
        material = .menu
        
        let animate = PassthroughSubject<Date, Never>()
        var tabs = [Tab]()
        
        let plus = Option(icon: "plus")
        plus.toolTip = "New tab"
        plus
            .click
            .sink {
                status.addTab()
            }
            .store(in: &subs)
        
        addSubview(plus)
        
        plus.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        plus.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        
        status
            .flows
            .removeDuplicates()
            .sink { [weak self] in
                guard let self = self else { return }
                var flows = $0
                tabs = tabs
                    .filter { tab in
                        guard flows.remove(where: { $0.id == tab.item.id }) == nil else { return true }
                        tab.left?.right = tab.right
                        tab.right?.left = tab.left
                        tab.removeFromSuperview()
                        return false
                    }
                
                flows
                    .reversed()
                    .forEach {
                        let tab = Tab(status: status, item: $0)
                        self.addSubview(tab)
                        
                        tabs.first?.left = tab
                        tab.right = tabs.first
                        tab.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 1).isActive = true
                        
                        tabs.insert(tab, at: 0)
                    }
                
                tabs.first?.align(left: plus.rightAnchor)
                animate.send(.now)
            }
            .store(in: &subs)
        
        status
            .current
            .sink { [weak self] current in
                guard let self = self else { return }
                self
                    .subviews
                    .compactMap {
                        $0 as? Tab
                    }
                    .forEach { tab in
                        tab.current = tab.item.id == current
                    }
                
                animate.send(.now)
            }
            .store(in: &subs)
        
        animate
            .removeDuplicates {
                $1.timeIntervalSince1970 - $0.timeIntervalSince1970 < 1
            }
            .sink { [weak self] _ in
                NSAnimationContext
                    .runAnimationGroup {
                        $0.allowsImplicitAnimation = true
                        $0.duration = 0.35
                        self?.layoutSubtreeIfNeeded()
                    }
            }
            .store(in: &subs)
    }
}
