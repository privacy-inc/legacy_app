import Foundation

extension String {
    var capped: String {
        count > 47 ? prefix(47) + "..." : self
    }
}
