import SwiftUI

extension Tabs {
    struct Snap: View {
        let image: UIImage?
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .frame(width: width, height: height)
                    .shadow(color: .primary.opacity(0.1), radius: 10)
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color(.systemBackground), style: .init(lineWidth: 2))
                    .frame(width: width, height: height)
                Image.init(uiImage: image ?? .init())
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
        }
    }
}
