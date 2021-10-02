import SwiftUI

extension Landing {
    final class Edit: UIHostingController<Landing.Edit.Content>, UIViewControllerRepresentable {
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            sheetPresentationController
                .map {
                    $0.detents = [.medium()]
                    $0.largestUndimmedDetentIdentifier = .medium
                }
        }
        
        func makeUIViewController(context: Context) -> Edit {
            self
        }
        
        func updateUIViewController(_: Edit, context: Context) {

        }
    }
}
