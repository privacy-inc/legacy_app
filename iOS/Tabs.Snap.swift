import SwiftUI

extension Tabs {
    struct Snap: View {
        let image: UIImage?
        let width: CGFloat?
        let height: CGFloat?
        private let container = RoundedRectangle(cornerRadius: 10, style: .continuous)
        
        var body: some View {
            ZStack {
                container
                    .fill(Color(.systemBackground))
                    .frame(width: width, height: height)
                    .shadow(color: .primary.opacity(0.1), radius: 10)
                container
                    .stroke(Color(.systemBackground), style: .init(lineWidth: 2))
                    .frame(width: width, height: height)
                Image(uiImage: image ?? .init())
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipShape(container)
            }
        }
    }
}
