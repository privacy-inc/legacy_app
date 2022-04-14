import SwiftUI

struct Bar<Leading, Trailing>: View where Leading : View, Trailing : View {
    let session: Session
    let leading: Leading
    let trailing: Trailing
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .ignoresSafeArea(edges: .horizontal)
            HStack(spacing: 0) {
                leading
                Spacer()
                
                Button {
//                    search()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 20, weight: .light))
                        .frame(width: 70, height: 34)
                        .contentShape(Rectangle())
                }
                
                Spacer()
                
                trailing
            }
            .foregroundStyle(.secondary)
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 2)
        }
//        .background(.thinMaterial)
    }
}
