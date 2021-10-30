import QuartzCore

extension Bar.Tab {
    final class Layer: CALayer {
        override class func defaultAction(forKey: String) -> CAAction? {
            switch forKey {
            case "position", "bounds":
                return super.defaultAction(forKey: forKey)
            default:
                return NSNull()
            }
        }
        
        override func hitTest(_: CGPoint) -> CALayer? {
            nil
        }
    }
}
