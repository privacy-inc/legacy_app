import SwiftUI
import Specs

struct Icon: View {
    var size = CGFloat(32)
    let icon: String?
    @State private var publisher: Favicon.Pub?
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let publisher = publisher {
                Group {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    } else {
                        globe
                    }
                }
                .onReceive(publisher) {
                    image = $0
                }
            } else {
                globe
            }
        }
        .frame(width: size, height: size)
        .allowsHitTesting(false)
        .onChange(of: icon) { new in
            Task
                .detached {
                    await update(icon: new)
                }
        }
        .task {
            await update(icon: icon)
        }
    }
    
    @MainActor private func update(icon: String?) async {
        image = nil
        publisher = nil
        if let icon = icon {
            publisher = await favicon.publisher(for: icon)
        }
    }
    
    private var globe: some View {
        Image(systemName: "globe")
            .font(.title.weight(.light))
            .foregroundStyle(.quaternary)
            .frame(width: size, height: size)
    }
}
