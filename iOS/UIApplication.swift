import UIKit

extension UIApplication {
    var snapshot: UIImage? {
        scene?
            .keyWindow?
            .rootViewController?
            .view
            .map { view in
                UIGraphicsImageRenderer(size: view.frame.size)
                    .image { _ in
                        view.drawHierarchy(in: view.frame, afterScreenUpdates: false)
                    }
            }
    }
    
    private var scene: UIWindowScene? {
        connectedScenes
            .filter {
                $0.activationState == .foregroundActive
            }
            .compactMap {
                $0 as? UIWindowScene
            }
            .first
    }
}
