import UIKit

struct Status: Identifiable {
    var image: UIImage?
    var history: UInt16?
    var error: String?
    var web: Web?
    let id = UUID()
}
