import AppKit
import Combine

extension Window {
    final class Content: NSVisualEffectView, NSTextFinderBarContainer {
        private weak var status: Status!
        private weak var findbar: Findbar!
        private var sub: AnyCancellable?
        private let finder = NSTextFinder()
        
        required init?(coder: NSCoder) { nil }
        init(status: Status, findbar: Findbar) {
            self.status = status
            self.findbar = findbar
            
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            state = .active
            material = .menu
            finder.findBarContainer = self
            
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
                        self.finder.client = web
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
        
        override var frame: NSRect {
            didSet {
                if frame.width > 600 {
                    let delta = frame.width - 600
                    status.widthOn.value = min(450, 200 + delta)
                    status.widthOff.value = min(150, 70 + delta)
                } else {
                    status.widthOn.value = 200
                    status.widthOff.value = 70
                }
            }
        }
        
        var findBarView: NSView? {
            didSet {
                oldValue?.removeFromSuperview()
                
                findBarView
                    .map {
                        $0.removeFromSuperview()
                        findbar.view = $0
                    }
            }
        }
        
        var isFindBarVisible = false {
            didSet {
                if !isFindBarVisible {
                    findbar.reset()
                }
            }
        }
        
        func findBarViewDidChangeHeight() {
            
        }
        
        override func performTextFinderAction(_ sender: Any?) {
            (sender as? NSMenuItem)
                .flatMap {
                    NSTextFinder.Action(rawValue: $0.tag)
                }
                .map {
                    finder.performAction($0)

                    switch $0 {
                    case .showFindInterface:
                        finder.findBarContainer?.isFindBarVisible = true
                    default: break
                    }
                }
        }
        
        @objc func findAction(_ sender: Any?) {
            performTextFinderAction(sender)
        }
    }
}
