import SwiftUI
import Combine
import Specs

extension Options {
    final class Representable: UIHostingController<Content>, UIViewControllerRepresentable {
        deinit {
            print("options gone")
        }
        
        private var sub: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init(web: Web, find: @escaping () -> Void) {
            print("options init")
            
            let share = PassthroughSubject<Void, Never>()
            
            super.init(rootView: .init(web: web, share: share, find: find))
            modalPresentationStyle = .overCurrentContext
            
            sub = share
                .sink { [weak self] in
                    guard let self = self else { return }
                    Task {
                        await self.share(web: web)
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
                }
        }
        
        func makeUIViewController(context: Context) -> Representable {
            self
        }
        
        func updateUIViewController(_: Representable, context: Context) {

        }
        
        @MainActor private func share(web: Web) async {
            let share = Share(web: web)
            share.popoverPresentationController?.sourceView = view
            share.completionWithItemsHandler = { [weak self] _, completed, _, _ in
                self?.dismiss(animated: true)
                
                if !completed {
                    DispatchQueue
                        .main
                        .asyncAfter(deadline: .now() + 0.2) { [weak self] in
                            self?.dismiss(animated: true)
                        }
                }
            }
            present(share, animated: true)
        }
    }

}