import AppKit
import Combine
import Specs

extension Tab {
    final class Off: Control {
        private var subs = Set<AnyCancellable>()
        private weak var close: Symbol!
        private weak var icon: Icon!
        private weak var title: Text!
        
        required init?(coder: NSCoder) { nil }
        init(session: Session, id: UUID, publisher: AnyPublisher<Session.Flow, Never>) {
            super.init(layer: true)
            layer!.cornerRadius = 8
            layer!.cornerCurve = .continuous
            
            click
                .sink {
                    session.current.send(id)
                }
                .store(in: &subs)
            
            let icon = Icon(size: 18)
            icon.icon(website: nil)
            icon.isHidden = true
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
            
            let close = Symbol("xmark.app.fill", point: 16, size: Bar.height, weight: .regular, hierarchical: false)
            close.toolTip = "Close tab"
            close
                .click
                .sink {
                    session.close(id: id)
                }
                .store(in: &subs)
            addSubview(close)
            self.close = close
            
            let width = widthAnchor.constraint(equalToConstant: session.width.value.off)
            width.isActive = true
            
            close.leftAnchor.constraint(equalTo: leftAnchor, constant: 3).isActive = true
            close.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            icon.centerXAnchor.constraint(equalTo: close.centerXAnchor).isActive = true
            icon.centerYAnchor.constraint(equalTo: close.centerYAnchor).isActive = true
            
            title.leftAnchor.constraint(equalTo: close.rightAnchor).isActive = true
            title.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -10).isActive = true
            title.centerYAnchor.constraint(equalTo: close.centerYAnchor, constant: -1).isActive = true
            
            publisher
                .first()
                .sink { [weak self] in
                    switch $0 {
                    case .list:
                        title.stringValue = "New tab"
                    case let .web(web):
                        icon.isHidden = false
                        close.state = .hidden
                        
                        self?.add(web
                            .publisher(for: \.url)
                            .compactMap {
                                $0
                            }
                            .sink {
                                icon.icon(website: $0)
                                title.stringValue = $0.absoluteString.domain
                            })
                    case let .message(_, info):
                        title.stringValue = info.url?.absoluteString.domain ?? ""
                    }
                }
                .store(in: &subs)
            
            session
                .width
                .dropFirst()
                .sink {
                    width.constant = $0.off
                }
                .store(in: &subs)
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .pressed, .highlighted:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
            default:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.03).cgColor
            }
        }
        
        override func mouseEntered(with: NSEvent) {
            super.mouseEntered(with: with)
            close.state = .on
            icon.isHidden = true
        }
        
        override func mouseExited(with: NSEvent) {
            super.mouseExited(with: with)
            guard icon.image.image != nil else { return }
            close.state = .hidden
            icon.isHidden = false
        }
        
        private func add(_ cancellable: AnyCancellable) {
            subs.insert(cancellable)
        }
    }
}
