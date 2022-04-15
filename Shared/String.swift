import Foundation

extension String {
    func capped(max: Int) -> Self {
        count > max ? prefix(max) + "..." : self
    }
}
