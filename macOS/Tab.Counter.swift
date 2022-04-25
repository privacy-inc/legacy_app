import AppKit
import Combine

extension Tab {
    final class Counter: Control {
        private weak var text: Text!
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(domain: CurrentValueSubject<String, Never>) {
            let text = Text(vibrancy: true)
            text.maximumNumberOfLines = 1
            text.lineBreakMode = .byTruncatingTail
            text.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
            self.text = text
            
            super.init(layer: true)
            toolTip = "Trackers"
            state = .hidden
            layer!.cornerRadius = 8
            addSubview(text)
            
            widthAnchor.constraint(equalToConstant: 41).isActive = true
            heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            text.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
            text.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -0.5).isActive = true
            
            click
                .sink { [weak self] in
                    guard let self = self else { return }
                    NSPopover().show(Trackers(domain: domain), from: self, edge: .minY)
                }
                .store(in: &subs)
            
            domain
                .combineLatest(cloud
                    .map(\.tracking)) {
                        $1.count(domain: $0)
                    }
                    .removeDuplicates()
                    .sink {
                        text.stringValue =  $0 < 1000 ? $0.formatted() : "􀯠"
                    }
                    .store(in: &subs)
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            NSApp.effectiveAppearance.performAsCurrentDrawingAppearance {
                switch state {
                case .pressed, .highlighted:
                    text.textColor = .labelColor
                    layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.2).cgColor
                default:
                    text.textColor = .secondaryLabelColor
                    layer!.backgroundColor = NSColor.separatorColor.cgColor
                }
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
