import AppKit
import Combine
import Specs

extension Bar.Tab {
    final class Off: Control {
        private var subs = Set<AnyCancellable>()
        private weak var close: Option!
        private weak var icon: Icon!
        private weak var title: Text!
        private let status: Status
        private let item: UUID
        
        required init?(coder: NSCoder) { nil }
        init(status: Status, item: UUID) {
            self.status = status
            self.item = item
            super.init(layer: true)
            layer!.cornerRadius = 8
            layer!.cornerCurve = .continuous
            
            menu = NSMenu()
            menu!.items = [
                .child("Close Tab", #selector(closeTab)) {
                    $0.target = self
                },
                .child("Close Other Tabs", #selector(closeOthers)) {
                    $0.target = self
                },
                .separator(),
                .child("Move Tab to New Window", #selector(moveToWindow)) {
                    $0.target = self
                }]
            
            click
                .sink {
                    status.current.send(item)
                }
                .store(in: &subs)
            
            let icon = Icon(size: 18)
            icon.icon(icon: nil)
            self.icon = icon
            addSubview(icon)
            
            let title = Text(vibrancy: true)
            title.font = .preferredFont(forTextStyle: .body)
            title.textColor = .secondaryLabelColor
            title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            title.maximumNumberOfLines = 1
            title.lineBreakMode = .byTruncatingTail
            self.title = title
            addSubview(title)
            
            let close = Option(icon: "xmark.app.fill")
            close.toolTip = "Close tab"
            close
                .click
                .sink { [weak self] in
                    self?.closeTab()
                }
                .store(in: &subs)
            addSubview(close)
            close.state = .hidden
            self.close = close
            
            let width = widthAnchor.constraint(equalToConstant: 70)
            width.isActive = true
            
            close.leftAnchor.constraint(equalTo: leftAnchor, constant: 3).isActive = true
            close.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            icon.centerXAnchor.constraint(equalTo: close.centerXAnchor).isActive = true
            icon.centerYAnchor.constraint(equalTo: close.centerYAnchor).isActive = true
            
            title.leftAnchor.constraint(equalTo: close.rightAnchor).isActive = true
            title.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -10).isActive = true
            title.centerYAnchor.constraint(equalTo: close.centerYAnchor, constant: -1).isActive = true
            
            status
                .items
                .compactMap {
                    $0
                        .first {
                            $0.id == item
                        }
                }
                .compactMap {
                    switch $0.flow {
                    case let .web(web), let .error(web, _):
                        return web
                    default:
                        return nil
                    }
                }
                .first()
                .sink { [weak self] (web: Web) in
                    self?.web(web: web)
                    width.constant = 150
                }
                .store(in: &subs)
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed, .highlighted:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.15).cgColor
            default:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            }
        }
        
        override func mouseEntered(with: NSEvent) {
            super.mouseEntered(with: with)
            close.state = .on
            icon.isHidden = true
        }
        
        override func mouseExited(with: NSEvent) {
            super.mouseExited(with: with)
            close.state = .hidden
            icon.isHidden = false
        }
        
        private func web(web: Web) {
            web
                .publisher(for: \.url)
                .flatMap { _ in
                    Future<AccessType?, Never> { promise in
                        Task {
                            guard let access = await cloud.website(history: web.history)?.access else {
                                promise(.success(nil))
                                return
                            }
                            promise(.success(access))
                        }
                    }
                }
                .compactMap {
                    $0
                }
                .sink { [weak self] access in
                    self?.icon.icon(icon: access.icon)
                    
                    switch access {
                    case let remote as Access.Remote:
                        self?.title.stringValue = remote.domain.minimal
                    default:
                        self?.title.stringValue = access.value
                    }
                }
                .store(in: &subs)
        }
        
        @objc private func closeTab() {
            status.close(id: item)
        }
        
        @objc private func closeOthers() {
            status.close(except: item)
        }
        
        @objc private func moveToWindow() {
            status.moveToNewWindow(id: item)
        }
    }
}
