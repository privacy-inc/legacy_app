import UIKit
import Specs

struct Status: Identifiable {
    var image: UIImage?
    var history: UInt16?
    var error: Err?
    var web: Web?
    let id = UUID()
}
