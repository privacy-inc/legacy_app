import SwiftUI
import Specs

struct Icon: View {
    let access: AccessType
    let publisher: Favicon.Pub
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipped()
            } else {
                Image(systemName: "app")
                    .font(.title.weight(.light))
                    .foregroundStyle(.quaternary)
            }
        }
        .frame(width: 32, height: 32)
        .onReceive(publisher) {
            image = $0
        }
    }
}
