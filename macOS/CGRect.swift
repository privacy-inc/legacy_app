import Foundation

extension CGRect: Hashable {
    public func hash(into: inout Hasher) {
        into.combine(origin.x)
        into.combine(origin.y)
        into.combine(size.width)
        into.combine(size.height)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.origin == rhs.origin
            && lhs.size == rhs.size
    }
}
