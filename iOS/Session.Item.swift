import UIKit

extension Session {
    struct Item: Identifiable {
        var thumbnail: UIImage?
//        var web: Web?
        var status: Status
        let id = UUID()
    }
}
