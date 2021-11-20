import AppKit

class CollectionCell<Info>: NSView where Info : CollectionItemInfo {
    var item: CollectionItem<Info>?
    
    required init?(coder: NSCoder) { nil }
    required init() {
        super.init(frame: .zero)
        layer = Layer()
        wantsLayer = true
        updateLayer()
    }
    
    final var state = CollectionCellState.none {
        didSet {
            updateLayer()
        }
    }
    
    final override func hitTest(_: NSPoint) -> NSView? {
        nil
    }
}
