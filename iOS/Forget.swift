import SwiftUI

final class Forget: UIHostingController<Forget.Content>, UIViewControllerRepresentable {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sheetPresentationController
            .map {
                $0.detents = [.medium()]
                $0.preferredCornerRadius = 36
            }
    }
    
    func makeUIViewController(context: Context) -> Forget {
        self
    }

    func updateUIViewController(_: Forget, context: Context) {

    }
}
