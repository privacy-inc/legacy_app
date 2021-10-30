import AppKit
import Combine

extension Bar.Tab {
    final class Off: Control {
        private var subs = Set<AnyCancellable>()
        private weak var close: Option!
        
        required init?(coder: NSCoder) { nil }
        init(status: Status, item: Status.Item) {
            super.init(layer: true)
            layer!.cornerRadius = 8
            layer!.cornerCurve = .continuous
            
            let close = Option(icon: "xmark.app.fill")
            close
                .click
                .sink {
                    status.close(id: item.id)
                }
                .store(in: &subs)
            addSubview(close)
            close.state = .hidden
            self.close = close
            
            click
                .sink {
                    status.current.send(item.id)
                }
                .store(in: &subs)
            
            close.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
            close.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
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
        }
        
        override func mouseExited(with: NSEvent) {
            super.mouseExited(with: with)
            close.state = .hidden
        }
    }
}
