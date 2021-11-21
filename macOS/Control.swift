import AppKit
import Combine

class Control: NSView {
    final var state = Control.State.on {
        didSet {
            guard state != oldValue else { return }
            updateLayer()
        }
    }
    
    final let click = PassthroughSubject<Void, Never>()
    
    required init?(coder: NSCoder) { nil }
    init(layer: Bool, animatable: Bool = false) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setAccessibilityElement(true)
        setAccessibilityRole(.button)
        addTrackingArea(.init(rect: bounds, options: [.mouseEnteredAndExited, .activeAlways, .inVisibleRect], owner: self))
        
        if layer {
            if !animatable {
                self.layer = Layer()
            }
            wantsLayer = layer
        }
        
        updateLayer()
    }
    
    override func updateLayer() {
        isHidden = state == .hidden
        alphaValue = state == .off ? 0.25 : 1
    }
    
    override func mouseEntered(with: NSEvent) {
        guard state == .on || state == .pressed else { return }
        state = .highlighted
    }
    
    override func mouseExited(with: NSEvent) {
        guard state == .highlighted || state == .pressed else { return }
        state = .on
    }
    
    final override func resetCursorRects() {
        addCursorRect(bounds, cursor: .arrow)
    }
    
    final override func mouseDown(with: NSEvent) {
        guard with.clickCount == 1, state == .on || state == .highlighted || state == .pressed else { return }
        window?.makeFirstResponder(nil)
        state = .pressed
    }
    
    final override func mouseUp(with: NSEvent) {
        guard state == .highlighted || state == .on || state == .pressed else { return }
        if bounds.contains(convert(with.locationInWindow, from: nil)) {
            click.send()
        }
        if state == .highlighted || state == .pressed {
            state = .on
        }
    }
    
    final override func shouldDelayWindowOrdering(for: NSEvent) -> Bool {
        true
    }
    
    final override var acceptsFirstResponder: Bool {
        true
    }
    
    final override var mouseDownCanMoveWindow: Bool {
        false
    }
    
    final override func acceptsFirstMouse(for: NSEvent?) -> Bool {
        true
    }
}
