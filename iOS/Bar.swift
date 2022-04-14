import SwiftUI

struct Bar: View {
    let session: Session
    let leading: (icon: String, action: () -> Void)
    let trailing: (icon: String, action: () -> Void)
    
    var body: some View {
        VStack(spacing: 0) {
//            Divider()
//                .ignoresSafeArea(edges: .horizontal)
            HStack(spacing: 0) {
                Button(action: leading.action) { image(icon: leading.icon) }
                
                Spacer()
                
                Button {
                    
                } label: {
                    image(icon: "magnifyingglass")
                }
                
                Spacer()
                
                Button(action: trailing.action) { image(icon: trailing.icon) }
            }
            .foregroundStyle(.secondary)
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 2)
        }
//        .background(.thinMaterial)
    }
    
    private func image(icon: String) -> some View {
        Image(systemName: icon)
            .symbolRenderingMode(.hierarchical)
            .font(.system(size: 20, weight: .light))
            .frame(width: 70, height: 34)
            .contentShape(Rectangle())
    }
}
