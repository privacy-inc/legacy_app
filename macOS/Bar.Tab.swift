import AppKit
import Combine

extension Bar {
    final class Tab: NSView {
        var current = false {
            didSet {
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(current ? 0.2 : 0.05).cgColor
            }
        }
        
        let id: UUID
        private var subs = Set<AnyCancellable>()
        
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
        
        private weak var rightGuide: NSLayoutConstraint? {
            didSet {
                oldValue?.isActive = false
                rightGuide?.isActive = true
            }
        }
        
        required init?(coder: NSCoder) { nil }
        init(id: UUID) {
            self.id = id
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            layer = Layer()
            wantsLayer = true
            layer!.cornerRadius = 8
            layer!.cornerCurve = .continuous
            
            heightAnchor.constraint(equalToConstant: 28).isActive = true
            widthAnchor.constraint(equalToConstant: 150).isActive = true
            
//            let background = Background(session: session, id: id)
//            let icon = Icon()
//
//            session
//                .current
//                .map {
//                    $0 == id
//                }
//                .removeDuplicates()
//                .sink { [weak self] in
//                    self?.view($0
//                                ? Search(session: session, id: id, background: background, icon: icon)
//                                : Thumbnail(session: session, id: id, icon: icon))
//
//                    NSAnimationContext
//                        .runAnimationGroup {
//                            $0.allowsImplicitAnimation = true
//                            $0.duration = 0.5
//                            self?.layoutSubtreeIfNeeded()
//                        }
//                }
//                .store(in: &subs)
//
//            session
//                .current
//                .filter {
//                    $0 != id
//                }
//                .map { _ in
//
//                }
//                .filter {
//                    session
//                        .tab
//                        .items
//                        .value[state: id]
//                        .isNew
//                }
//                .filter {
//                    session
//                        .tab
//                        .items
//                        .value
//                        .count > 1
//                }
//                .sink {
//                    session.close.send(id)
//                }
//                .store(in: &subs)
//
//            cloud
//                .archive
//                .combineLatest(session
//                                .tab
//                                .items
//                                .map {
//                                    $0[state: id]
//                                        .browse
//                                }
//                                .compactMap {
//                                    $0
//                                }
//                                .removeDuplicates())
//                .map {
//                    $0.0
//                        .page($0.1)
//                        .title
//                }
//                .removeDuplicates()
//                .sink { [weak self] in
//                    self?.toolTip = $0
//                }
//                .store(in: &subs)
//
//            cloud
//                .archive
//                .combineLatest(session
//                                .tab
//                                .items
//                                .map {
//                                    $0[state: id]
//                                        .browse
//                                }
//                                .compactMap {
//                                    $0
//                                }
//                                .removeDuplicates())
//                .map {
//                    $0.0
//                        .page($0.1)
//                        .access
//                        .short
//                }
//                .removeDuplicates()
//                .subscribe(icon
//                            .domain)
//                .store(in: &subs)
        }
        
        func align(left: NSLayoutXAxisAnchor) {
            leftGuide = leftAnchor.constraint(equalTo: left, constant: 10)
        }
        
//        private func view(_ content: NSView) {
//            subviews
//                .forEach {
//                    $0.removeFromSuperview()
//                }
//            addSubview(content)
//
//            rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
//
//            content.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//            content.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
