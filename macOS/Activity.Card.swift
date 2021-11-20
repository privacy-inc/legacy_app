import AppKit
import Combine

extension Activity {
    final class Card: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            let layer = Layer()
            self.layer = layer
            wantsLayer = true
            shadow = NSShadow()
            shadow!.shadowColor = .init(white: 0, alpha: 0.2)
            layer.backgroundColor = NSColor.controlBackgroundColor.cgColor
            layer.cornerCurve = .continuous
            layer.cornerRadius = 14
            layer.shadowOffset = .zero
            layer.shadowRadius = 5
            
            widthAnchor.constraint(equalToConstant: 300).isActive = true
            
            cloud
                .map(\.events.stats.timeline)
                .removeDuplicates()
                .sink {
                    layer
                        .sublayers?
                        .forEach {
                            $0.removeFromSuperlayer()
                        }
                    
                    layer.addSublayer(Chart(values: $0))
                }
                .store(in: &subs)
        }
        
        override func hitTest(_: NSPoint) -> NSView? {
            nil
        }
    }
}
