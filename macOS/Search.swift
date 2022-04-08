import AppKit

final class Search: NSTextField {
    required init?(coder: NSCoder) { nil }
    init() {
        Self.cellClass = Cell.self
        super.init(frame: .zero)
        bezelStyle = .roundedBezel
        translatesAutoresizingMaskIntoConstraints = false
        font = .preferredFont(forTextStyle: .body)
        controlSize = .large
        lineBreakMode = .byTruncatingTail
        textColor = .labelColor
        isAutomaticTextCompletionEnabled = false
    }

    deinit {
        NSApp
            .windows
            .forEach {
                $0.undoManager?.removeAllActions()
            }
    }
    
    override var canBecomeKeyView: Bool {
        true
    }
    
    override func mouseDown(with: NSEvent) {
        selectText(nil)
    }
}
