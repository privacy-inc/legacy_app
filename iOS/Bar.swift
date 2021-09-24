import SwiftUI

struct Bar<Leading, Trailing>: View where Leading : View, Trailing : View {
    let search: () -> Void
    private let leading: Leading
    private let trailing: Trailing
    @State private var offset = CGFloat(100)
    @Environment(\.verticalSizeClass) private var vertical
    
    @inlinable init(search: @escaping () -> Void, @ViewBuilder leading: () -> Leading, @ViewBuilder trailing: () -> Trailing) {
        self.search = search
        self.leading = leading()
        self.trailing = trailing()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(HierarchicalShapeStyle.quaternary)
                .frame(height: 0.5)
                .edgesIgnoringSafeArea(.horizontal)
            HStack {
                leading
                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        offset = 100
                    }
                    search()
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color("Shades"))
                            .frame(width: 38, height: 38)
                        Image(systemName: "magnifyingglass")
                            .font(.callout)
                            .foregroundColor(.init(.systemBackground))
                    }
                }
                trailing
            }
            .padding(.horizontal)
            .padding(.top, vertical == .compact ? 2 : 8)
            .padding(.bottom, 2)
        }
        .background(.ultraThinMaterial)
        .offset(y: offset)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.4)) {
                offset = 0
            }
        }
    }
}
