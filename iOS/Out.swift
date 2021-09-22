import SwiftUI

struct Out: View {
    let image: UIImage?
    @State private var width: CGFloat?
    @State private var height: CGFloat?
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThickMaterial)
            Tabs.Snap(image: image, width: width, height: height)
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
