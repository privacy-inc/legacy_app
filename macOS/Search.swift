import AppKit
import Combine

final class Search: NSTextField {
    private var sub: AnyCancellable?
    
    required init?(coder: NSCoder) { nil }
    init(status: Status) {
        Self.cellClass = Cell.self
        super.init(frame: .zero)
        bezelStyle = .roundedBezel
        translatesAutoresizingMaskIntoConstraints = false
        font = .preferredFont(forTextStyle: .body)
        controlSize = .large
        lineBreakMode = .byTruncatingTail
        textColor = .labelColor
        isAutomaticTextCompletionEnabled = false
        
        sub = status
            .complete
            .sink { [weak self] in
                self?.stringValue = $0
            }
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
