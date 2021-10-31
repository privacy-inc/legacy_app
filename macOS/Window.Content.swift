import AppKit
import Combine

extension Window {
    final class Content: NSVisualEffectView {
        private var sub: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init(status: Status) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            state = .active
            material = .menu
            
            let separator = Separator(mode: .horizontal)
            separator.alphaValue = 0
            addSubview(separator)
            
            separator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
            separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            
            sub = status
                .flows
                .combineLatest(status
                                .current)
                .compactMap { flows, current in
                    flows
                        .first {
                            $0.id == current
                        }
                }
                .removeDuplicates()
                .removeDuplicates {
                    $0.flow == .landing && $1.flow == .landing
                }
                .sink { [weak self] item in
                    guard let self = self else { return }
                    
                    self
                        .subviews
                        .filter {
                            $0 != separator
                        }
                        .forEach {
                            $0.removeFromSuperview()
                        }
                    
                    print("flow")
                    
                    let view: NSView
                    
                    switch item.flow {
                    case .landing:
                        view = Landing()
                    case let .web(web):
                        view = web
                    default:
                        view = .init()
                    }
                    
                    view.translatesAutoresizingMaskIntoConstraints = false
                    self.addSubview(view)

                    view.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
                    view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                    view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                    view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
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
    }
}
