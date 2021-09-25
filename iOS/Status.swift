import UIKit

struct Status: Identifiable {
    var image: UIImage?
    var history: Int?
    var error: String?
    var title = "New"
    let id = UUID()
}
