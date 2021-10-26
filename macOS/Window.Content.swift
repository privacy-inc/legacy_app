import AppKit
import Combine

extension Window {
    final class Content: NSVisualEffectView {
        let status = Status()
        private var sub: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            state = .active
            material = .menu
            
            sub = status
                .flows
                .combineLatest(status
                                .current)
                .compactMap {
                    $0[$1]
                }
                .removeDuplicates()
                .sink { [weak self] flow in
                    
                }
            
//            
//            let separator = Separator(mode: .horizontal)
//            bar.addSubview(separator)
//            
//            sub = session
//                .tab
//                .items
//                .combineLatest(session
//                                .current
//                                .removeDuplicates())
//                .map {
//                    (state: $0[state: $1], id: $1)
//                }
//                .removeDuplicates {
//                    $0.state == $1.state && $0.id == $1.id
//                }
//                .sink { [weak self] in
//                    switch $0.state {
//                    case .new:
//                        self?.update(display: New(session: session, id: $0.id))
//                    case let .browse(browse):
//                        let web = (session.tab.items.value[web: $0.id] as? Web) ?? Web(session: session, id: $0.id, browse: browse)
//                        if session.tab.items.value[web: $0.id] == nil {
//                            session.tab.update($0.id, web: web)
//                        }
//                        let browser = Browser(web: web)
//                        self?.update(display: browser)
//                        self?.window?.makeFirstResponder(web)
//                    case let .error(browse, error):
//                        let display = Error(session: session, id: $0.id, browse: browse, error: error)
//                        self?.update(display: display)
//                        self?.window?.makeFirstResponder(display)
//                    }
//                }
//            
//            bar.topAnchor.constraint(equalTo: topAnchor).isActive = true
//            bar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//            bar.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//            bar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 1).isActive = true
//            
//            separator.bottomAnchor.constraint(equalTo: bar.bottomAnchor).isActive = true
//            separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//            separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        }
        
//        private func update(display: NSView) {
//            self.display?.removeFromSuperview()
//            addSubview(display)
//
//            display.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 1).isActive = true
//            display.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//            display.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//            display.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//            self.display = display
//        }
    }
}
