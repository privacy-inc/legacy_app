import SwiftUI

extension Tabs {
    struct Snap: View {
        let image: UIImage?
        let size: CGFloat?
        private let container = RoundedRectangle(cornerRadius: 10, style: .continuous)
        
        var body: some View {
            ZStack {
                container
                    .fill(Color(.systemBackground))
                    .frame(width: size, height: size)
                    .shadow(color: .primary.opacity(0.1), radius: 10)
                container
                    .stroke(Color(.systemBackground), style: .init(lineWidth: 2))
                    .frame(width: size, height: size)
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .clipShape(container)
                } else {
                    Image(systemName: "globe.europe.africa.fill")
                        .foregroundColor(.init("Shades"))
                        .font(.largeTitle)
                }
            }
        }
    }
}