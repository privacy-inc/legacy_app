import AppKit
import Combine

extension Window {
    final class Content: NSVisualEffectView {
        private var sub: AnyCancellable?
        private let finder = NSTextFinder()
        
        required init?(coder: NSCoder) { nil }
        init(status: Status, findbar: Findbar) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            state = .active
            material = .menu
            
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
                        .forEach {
                            $0.removeFromSuperview()
                        }
                    
                    let view: NSView
                    
                    switch item.flow {
                    case .landing:
                        view = Landing(status: status)
                        findbar.isHidden = true
                    case let .web(web):
                        web.finder = self.finder
                        self.finder.client = web
                        self.finder.findBarContainer = web
                        view = web
                        findbar.isHidden = false
                    case let .error(_, error):
                        view = Recover(error: error)
                        findbar.isHidden = true
                    }
                    
                    view.translatesAutoresizingMaskIntoConstraints = false
                    self.addSubview(view)
                    self.window?.makeFirstResponder(view)
                    
                    view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
                    view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                    view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                    view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                }
        }
    }
}
