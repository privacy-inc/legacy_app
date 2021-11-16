import AppKit
import Combine

extension Window {
    final class Content: NSVisualEffectView {
        private var sub: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init(status: Status, finder: Finder) {
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
                .items
                .combineLatest(status
                                .current)
                .compactMap { items, current in
                    items
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
                    
                    let view: NSView
                    
                    switch item.flow {
                    case .landing:
                        view = Landing(status: status)
                        finder.isHidden = true
                    case let .web(web):
                        view = web
                        finder.isHidden = false
                    case let .error(_, error):
                        view = Recover(error: error)
                        finder.isHidden = true
                    }
                    
                    view.translatesAutoresizingMaskIntoConstraints = false
                    self.addSubview(view)
                    
                    view.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
                    view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                    view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                    view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                }
        }
    }
}
