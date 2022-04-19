import SwiftUI
import Combine

final class Detail: UIHostingController<Detail.Content>, UIViewControllerRepresentable, UISheetPresentationControllerDelegate {
    private let status: Browser.Status
    private var sub: AnyCancellable?

    required init?(coder: NSCoder) { nil }
    init(status: Browser.Status, session: Session, index: Int) {
        self.status = status
        super.init(rootView: .init(status: status, session: session, index: index))
        modalPresentationStyle = .overCurrentContext
        
        sub = status
            .features
            .sink { [weak self] in
                self?.sheetPresentationController?.animateChanges {
                    self?.sheetPresentationController?.selectedDetentIdentifier = .large
                }
            }
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
