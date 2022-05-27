import Foundation

extension CGRect: Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.origin == rhs.origin
            && lhs.size == rhs.size
    }
    
    public func hash(into: inout Hasher) {
        into.combine(origin.x)
        into.combine(origin.y)
        into.combine(size.width)
        into.combine(size.height)
    }
    
    var bounded: Self {
        .init(x: max(0, minX), y: max(0, minY), width: width, height: height)
    }
}
