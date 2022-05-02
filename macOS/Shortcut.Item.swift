import AppKit
import Combine

extension Shortcut {
    final class Item: Control {
        private weak var background: Vibrant!
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(window: Window, item: Session.Item) {
            let background = Vibrant(layer: true)
            background.layer!.cornerRadius = 8
            self.background = background
            
            super.init(layer: true)
            layer!.masksToBounds = false
            addSubview(background)
            
            let separator = Separator()
            addSubview(separator)
            
            let text = Text(vibrancy: true)
            text.font = .preferredFont(forTextStyle: .body)
            text.textColor = .labelColor
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            text.maximumNumberOfLines = 1
            text.lineBreakMode = .byTruncatingTail
            addSubview(text)
            
            if window == NSApp.mainWindow && window.session.current.value == item.id {
                let check = NSImageView(image: .init(systemSymbolName: "checkmark.circle.fill", accessibilityDescription: nil) ?? .init())
                check.translatesAutoresizingMaskIntoConstraints = false
                check.symbolConfiguration = .init(pointSize: 24, weight: .medium)
                check.contentTintColor = .systemBlue
                addSubview(check)
                
                check.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
                check.widthAnchor.constraint(equalToConstant: 35).isActive = true
                check.heightAnchor.constraint(equalTo: check.widthAnchor).isActive = true
                check.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

                text.rightAnchor.constraint(lessThanOrEqualTo: check.leftAnchor, constant: -15).isActive = true
            } else {
                text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -55).isActive = true
            }
            
            heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            background.topAnchor.constraint(equalTo: topAnchor).isActive = true
            background.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            background.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            background.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            separator.topAnchor.constraint(equalTo: bottomAnchor, constant: 0.5).isActive = true
            separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
            separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            switch item.flow {
            case .list:
                text.stringValue = "New tab"
                text.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
                
            case let .web(web):
                let icon = Icon(size: 20)
                addSubview(icon)
                
                icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
                
                text.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 10).isActive = true
                
                web
                    .publisher(for: \.title)
                    .compactMap {
                        $0
                    }
                    .removeDuplicates()
                    .sink {
                        text.stringValue = $0
                    }
                    .store(in: &subs)
                
                web
                    .publisher(for: \.url)
                    .removeDuplicates()
                    .sink(receiveValue: icon.icon(website:))
                    .store(in: &subs)
                
            case let .message(_, info):
                text.stringValue = info.title
                
                let icon = NSImageView(image: .init(systemSymbolName: info.icon, accessibilityDescription: nil) ?? .init())
                icon.translatesAutoresizingMaskIntoConstraints = false
                icon.symbolConfiguration = .init(pointSize: 22, weight: .regular)
                    .applying(.init(hierarchicalColor: .secondaryLabelColor))
                addSubview(icon)
                
                icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
                icon.widthAnchor.constraint(equalToConstant: 40).isActive = true
                icon.heightAnchor.constraint(equalTo: icon.widthAnchor).isActive = true
                
                text.leftAnchor.constraint(equalTo: icon.rightAnchor).isActive = true
            }
            
            click
                .first()
                .sink {
                    NSApp.activate(ignoringOtherApps: true)
                    window.makeKeyAndOrderFront(nil)
                    window.session.current.send(item.id)
                }
                .store(in: &subs)
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            NSApp.effectiveAppearance.performAsCurrentDrawingAppearance {
                switch state {
                case .highlighted, .pressed, .selected:
                    background.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
                default:
                    background.layer!.backgroundColor = .clear
                }
            }
        }
    }
}
