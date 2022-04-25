import AppKit

final class Stack: NSStackView {
    override func updateLayer() {
        views
            .forEach {
                $0.updateLayer()
            }
    }
}
