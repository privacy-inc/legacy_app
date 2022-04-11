import AppKit
import Combine

extension Shortcut {
    final class Item: Control {
        private var sub: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init(window: Window, item: Status.Item, width: CGFloat) {
            super.init(layer: true)
            layer!.cornerRadius = 6
            layer!.masksToBounds = false
            
            let text = Text(vibrancy: true)
            text.font = .preferredFont(forTextStyle: .callout)
            text.textColor = .secondaryLabelColor
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            text.maximumNumberOfLines = 1
            text.lineBreakMode = .byTruncatingTail
            addSubview(text)
            
            let separator = CAShapeLayer()
            separator.fillColor = .clear
            separator.lineWidth = 1
            separator.strokeColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
            separator.path = .init(rect: .init(x: 5, y: -0.5, width: width - 40, height: 0), transform: nil)
            layer!.addSublayer(separator)
            
            if window == NSApp.mainWindow && window.status.current.value == item.id {
                let check = NSImageView(image: .init(systemSymbolName: "checkmark.circle.fill", accessibilityDescription: nil) ?? .init())
                check.translatesAutoresizingMaskIntoConstraints = false
                check.symbolConfiguration = .init(pointSize: 24, weight: .medium)
                    .applying(.init(hierarchicalColor: .systemBlue))
                addSubview(check)
                
                check.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
                check.widthAnchor.constraint(equalToConstant: 20).isActive = true
                check.heightAnchor.constraint(equalTo: check.widthAnchor).isActive = true
                check.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

                text.rightAnchor.constraint(lessThanOrEqualTo: check.leftAnchor, constant: -5).isActive = true
            } else {
                text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -30).isActive = true
            }
            
            heightAnchor.constraint(equalToConstant: 39).isActive = true
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            switch item.flow {
            case .list:
                text.stringValue = "New tab"
                text.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
                
            case let .web(web):
                text.stringValue = web.title ?? web.url?.absoluteString.domain ?? ""
                
                let icon = Icon(size: 18)
                icon.icon(website: web.url)
                addSubview(icon)
                
                icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
                
                text.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 4).isActive = true
            case let .message(_, _, title, image):
                text.stringValue = title
                
                let icon = NSImageView(image: .init(systemSymbolName: image, accessibilityDescription: nil) ?? .init())
                icon.translatesAutoresizingMaskIntoConstraints = false
                icon.symbolConfiguration = .init(pointSize: 20, weight: .regular)
                    .applying(.init(hierarchicalColor: .secondaryLabelColor))
                addSubview(icon)
                
                icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
                icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
                icon.heightAnchor.constraint(equalTo: icon.widthAnchor).isActive = true
                
                text.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 4).isActive = true
            }
            
            sub = click
                .first()
                .sink {
                    NSApp.activate(ignoringOtherApps: true)
                    window.makeKeyAndOrderFront(nil)
                    window.status.current.send(item.id)
                }
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .highlighted, .pressed, .selected:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
            default:
                layer!.backgroundColor = .clear
            }
        }
    }
}
