import SwiftUI

final class Options: UIHostingController<Options.Content>, UIViewControllerRepresentable {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sheetPresentationController
            .map {
                $0.detents = [.medium(), .large()]
                $0.largestUndimmedDetentIdentifier = .medium
            }
    }
    
    func makeUIViewController(context: Context) -> Options {
        self
    }
    
    func updateUIViewController(_: Options, context: Context) {

    }
}
