import UIKit
import StoreKit

extension UIApplication {
    func settings() {
        open(URL(string: Self.openSettingsURLString)!)
    }
    
    func hide() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    @MainActor func review() {
        scene
            .map(SKStoreReviewController.requestReview(in:))
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
        { (connected: [UIWindowScene]) -> UIWindowScene? in
            connected.count > 1
            ? connected
                .filter {
                    $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive
                }
                .first
            : connected
                .first
        } (connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            })
    }
}
