import AppKit
import Combine

extension Bar.Tab.On {
    final class Background: NSView, CAAnimationDelegate {
        private weak var shape: Shape!
        private var subscription: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            layer = Layer()
            wantsLayer = true
            layer!.cornerRadius = 8
            layer!.cornerCurve = .continuous

            let shape = Shape()
            shape.strokeStart = 0
            shape.strokeEnd = 0
            shape.fillColor = .clear
            shape.lineWidth = 2
            shape.lineCap = .round
            shape.lineJoin = .round
            layer!.addSublayer(shape)
            self.shape = shape
        }
        
        func listen(web: Web) {
            subscription = web
                .progress
                .removeDuplicates()
                .sink { [weak self] progress in
                    
                    guard progress != 1 || self?.shape.strokeEnd != 0 else { return }
                    
                    self?.shape.strokeStart = 0
                    self?.shape.strokeEnd = .init(progress)
                    
                    if progress == 1 {
                        self?.shape.add({
                            $0.duration = 1
                            $0.timingFunction = .init(name: .easeInEaseOut)
                            $0.delegate = self
                            return $0
                        } (CABasicAnimation(keyPath: "strokeEnd")), forKey: "strokeEnd")
                    } else {
                        self?.shape.path = {
                            $0.move(to: .init(x: 0, y: 1.3))
                            $0.addLine(to: .init(x: self?.frame.width ?? 0, y: 1.3))
                            return $0
                        } (CGMutablePath())
                    }
                }
        }
        
        func animationDidStop(_: CAAnimation, finished: Bool) {
            if finished {
                shape.strokeStart = 1
                shape.add({
                    $0.duration = 1
                    $0.timingFunction = .init(name: .easeInEaseOut)
                    return $0
                } (CABasicAnimation(keyPath: "strokeStart")), forKey: "strokeStart")
            }
        }
        
        override func updateLayer() {
            layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.15).cgColor
            shape.strokeColor = NSColor(named: "Shades")!.cgColor
        }
        
        override var allowsVibrancy: Bool {
            true
        }
        
        override func hitTest(_: NSPoint) -> NSView? {
            nil
        }
    }
}
