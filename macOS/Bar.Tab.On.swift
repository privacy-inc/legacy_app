import AppKit
import Combine

extension Bar.Tab {
    final class On: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(status: Status, item: Status.Item) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            layer = Privacy.Layer()
            wantsLayer = true
            layer!.cornerRadius = 8
            layer!.cornerCurve = .continuous
            layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.15).cgColor   
        }
    }
}
