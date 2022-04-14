import UIKit

extension Session {
    struct Item: Identifiable {
        var thumbnail: UIImage?
        var web: Web?
        let id = UUID()
    }
}
