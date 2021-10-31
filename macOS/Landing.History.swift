import AppKit
import Combine
import Specs

extension Landing {
    final class History: Section {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            header.stringValue = "History"
            
            bottomAnchor.constraint(greaterThanOrEqualTo: header.bottomAnchor, constant: 10).isActive = true
            
            cloud
                .map {
                    $0
                        .history
                        .prefix(6)
                }
                .removeDuplicates {
                    $0.map(\.website.access.value) == $1.map(\.website.access.value)
                }
                .sink { [weak self] history in
                    guard let self = self else { return }
                    
                    self
                        .subviews
                        .filter {
                            $0 != self.header
                        }
                        .forEach {
                            $0.removeFromSuperview()
                        }
                    
                    var top = self.header.bottomAnchor

                    history
                        .forEach { item in
                            let view: NSView
                            switch item.website.access {
                            case let remote as Access.Remote:
                                view = Remote(item: item, remote: remote)
                            default:
                                view = Other(item: item)
                            }
                            
                            self.addSubview(view)
                            
                            if top != self.header.bottomAnchor {
                                let separator = Separator(mode: .horizontal)
                                self.addSubview(separator)
                                
                                separator.topAnchor.constraint(equalTo: top).isActive = true
                                separator.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                                separator.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                                top = separator.bottomAnchor
                            }
                            
                            view.topAnchor.constraint(equalTo: top, constant: top == self.header.bottomAnchor ? 10 : 0).isActive = true
                            view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                            view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                            top = view.bottomAnchor
                        }
                    
                    if !history.isEmpty {
                        self.bottomAnchor.constraint(equalTo: top).isActive = true
                    }
                }
                .store(in: &subs)
        }
    }
}
