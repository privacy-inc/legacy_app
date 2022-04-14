import SwiftUI
import Combine
import Specs

final class Icon: ObservableObject {
    @Published private(set) var image: UIImage?
    private var publisher: Favicon.Pub?
    private var sub: AnyCancellable?
    
    func load(website: URL?) async {
        guard let website = website else { return }
        publisher = await favicon.publisher(for: website)
        sub = publisher?
            .sink { [weak self] in
                self?.image = $0
            }
    }
//    
//    
//    let imagea: Image = Image(uiImage: .init())
//        .resizable()
//        .scaledToFit()
////        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
//    
//    var body: some View {
//        Group {
//            if let publisher = publisher {
//                Group {
//                    if let image = image {
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFit()
//                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
//                    }
//                }
//                .onReceive(publisher) {
//                    image = $0
//                }
//            }
//        }
//        .frame(width: size, height: size)
//        .allowsHitTesting(false)
//        .onChange(of: website) { new in
//            Task
//                .detached {
//                    await update(website: new)
//                }
//        }
//        .task {
//            await update(website: website)
//        }
//    }
//    
//    @MainActor private func update(website: URL?) async {
//        image = nil
//        publisher = nil
//        if let website = website {
//            publisher = await favicon.publisher(for: website)
//        }
//    }
}
