import UIKit

extension Session {
    struct Item: Identifiable, Equatable {
        var thumbnail: UIImage?
        var web: Web?
        let id = UUID()
    }
}
