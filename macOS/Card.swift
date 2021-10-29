import AppKit

final class Card: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer = Layer()
        wantsLayer = true
        layer!.cornerCurve = .continuous
        layer!.cornerRadius = 14
        layer!.borderColor = NSColor.quaternaryLabelColor.cgColor
        layer!.borderWidth = 1
    }
}
