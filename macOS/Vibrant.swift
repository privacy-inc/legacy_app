import AppKit

final class Vibrant: NSView {
    required init?(coder: NSCoder) { nil }
    init(layer: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        if layer {
            self.layer = Layer()
            wantsLayer = true
        }
    }
    
    override var allowsVibrancy: Bool {
        true
    }
    
    override func hitTest(_: NSPoint) -> NSView? {
        nil
    }
}
