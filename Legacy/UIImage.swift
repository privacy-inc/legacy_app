import UIKit

extension UIImage {
    static let blank: UIImage = {
        UIGraphicsBeginImageContext(.init(width: 32, height: 32))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    } ()
}
