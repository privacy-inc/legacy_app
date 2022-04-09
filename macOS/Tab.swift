import AppKit
import Combine

final class Tab: NSView, NSMenuDelegate {
    let id: UUID
    private let publisher: AnyPublisher<Web, Never>
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
    init(status: Status, id: UUID, current: Bool) {
        self.status = status
        self.id = id
        self.current = current
        
        publisher = status
            .items
            .compactMap {
                $0
                    .first {
                        $0.id == id
                    }
            }
            .compactMap {
                switch $0.flow {
                case let .web(web), let .message(web, _, _, _):
                    return web
                default:
                    return nil
                }
            }
            .eraseToAnyPublisher()
        
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
            view = On(status: status, id: id, publisher: publisher)
        } else {
            view = Off(status: status, id: id, publisher: publisher)
        }
        addSubview(view)
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    @objc private func closeTab() {
        status.close(id: id)
    }
    
    @objc private func closeOthers() {
        status.close(except: id)
    }
    
    @objc private func moveToWindow() {
        status.toNewWindow(id: id)
    }
}
