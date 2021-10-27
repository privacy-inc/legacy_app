import AppKit

final class Landing: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        wantsLayer = true
        layer!.backgroundColor = .black
    }
}
