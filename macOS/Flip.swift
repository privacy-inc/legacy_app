import AppKit

final class Flip: NSView {
    override var isFlipped: Bool {
        true
    }
    
    override func acceptsFirstMouse(for: NSEvent?) -> Bool {
        true
    }
}
