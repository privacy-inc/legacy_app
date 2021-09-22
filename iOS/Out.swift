import SwiftUI

struct Out: View {
    let image: UIImage?
    @State private var width: CGFloat?
    @State private var height: CGFloat?
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThickMaterial)
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
        .edgesIgnoringSafeArea(.all)
        .task {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.3)) {
                width = 150
                height = 150
            }
        }
    }
}
