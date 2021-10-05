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
    
    var dark: Bool {
        scene?
            .keyWindow?
            .rootViewController?
            .traitCollection
            .userInterfaceStyle == .dark
    }
    
    func settings() {
        open(URL(string: Self.openSettingsURLString)!)
    }
    
    func hide() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func share(_ any: Any) {
        scene?
            .keyWindow?
            .rootViewController
            .map {
                let controller = UIActivityViewController(activityItems: [any], applicationActivities: nil)
                controller.popoverPresentationController?.sourceView = $0.view
                $0.present(controller, animated: true)
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
