import AppKit

class CollectionCell<Info>: CALayer where Info : CollectionItemInfo {
    var item: CollectionItem<Info>?
    
    required init?(coder: NSCoder) { nil }
    override init(layer: Any) { super.init(layer: layer) }
    required override init() {
        super.init()
    }
    
    func update() {
        
    }
    
    final var state = CollectionCellState.none {
        didSet {
            update()
        }
    }
    
    final override func hitTest(_: CGPoint) -> CALayer? {
        nil
    }
    
    final override class func defaultAction(forKey: String) -> CAAction? {
        NSNull()
    }
}
