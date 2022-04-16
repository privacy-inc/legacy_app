import SwiftUI

final class Detail: UIHostingController<Detail.Content>, UIViewControllerRepresentable, UISheetPresentationControllerDelegate {
    private let status = Status()
    
    required init?(coder: NSCoder) { nil }
    init(web: Web) {
        super.init(rootView: .init(status: status, web: web))
        modalPresentationStyle = .overCurrentContext
    }

    override func willMove(toParent: UIViewController?) {
        super.willMove(toParent: toParent)
        parent?.modalPresentationStyle = .overCurrentContext
        parent?.view.backgroundColor = .clear
        view.backgroundColor = .clear
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sheetPresentationController
            .map {
                $0.detents = [.medium(), .large()]
                $0.preferredCornerRadius = 16
                $0.prefersGrabberVisible = true
                $0.delegate = self
            }
    }
    
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        status.small = sheetPresentationController.selectedDetentIdentifier == .medium
    }

    func makeUIViewController(context: Context) -> Detail {
        self
    }

    func updateUIViewController(_: Detail, context: Context) {

    }
}
