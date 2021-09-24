import UIKit

struct Status: Identifiable {
    var image: UIImage?
    var browse: Int?
    var error: String?
    var title = "New"
    let id = UUID()
}
