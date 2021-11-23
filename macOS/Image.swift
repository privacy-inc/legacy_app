import AppKit

final class Image: NSImageView {
    private let moves: Bool
    
    required init?(coder: NSCoder) { nil }
    convenience init(icon: String, moves: Bool = false) {
        self.init(moves: moves)
        image = .init(systemSymbolName: icon, accessibilityDescription: nil)
    }

    convenience init(named: String, moves: Bool = false) {
        self.init(moves: moves)
        image = .init(named: named)
    }
    
    init(moves: Bool = false) {
        self.moves = moves
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func hitTest(_: NSPoint) -> NSView? {
        nil
    }
    
    override var mouseDownCanMoveWindow: Bool {
        moves
    }
}
