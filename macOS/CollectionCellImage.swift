import QuartzCore

final class CollectionCellImage: CALayer {
    required init?(coder: NSCoder) { nil }
    override init(layer: Any) { super.init(layer: layer) }
    override init() {
        super.init()
        contentsGravity = .resizeAspect
        masksToBounds = true
    }
    
    override func hitTest(_: CGPoint) -> CALayer? {
        nil
    }
    
    override class func defaultAction(forKey: String) -> CAAction? {
        NSNull()
    }
}
