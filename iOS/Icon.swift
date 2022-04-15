import SwiftUI
import Combine
import Specs

final class Icon: ObservableObject {
    @Published private(set) var image: UIImage?
    private var publisher: Favicon.Pub?
    private var sub: AnyCancellable?
    
    func load(website: URL?) async {
        guard let website = website else { fatalError() }
        publisher = await favicon.publisher(for: website)
        sub = publisher?
            .sink { [weak self] in
                self?.image = $0
            }
    }
}
