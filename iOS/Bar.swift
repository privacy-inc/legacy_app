import SwiftUI

struct Bar<Leading, Trailing>: View where Leading : View, Trailing : View {
    let search: () -> Void
    private let leading: Leading
    private let trailing: Trailing
    @Environment(\.verticalSizeClass) private var vertical
    
    @inlinable init(search: @escaping () -> Void, @ViewBuilder leading: () -> Leading, @ViewBuilder trailing: () -> Trailing) {
        self.search = search
        self.leading = leading()
        self.trailing = trailing()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.secondary)
                .frame(height: 0.5)
                .edgesIgnoringSafeArea(.horizontal)
            HStack(spacing: 0) {
                leading
                Button {
                    search()
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.secondary)
                            .frame(width: 38, height: 38)
                        Image(systemName: "magnifyingglass")
                            .font(.callout)
                            .foregroundColor(.primary)
                    }
                }
                trailing
            }
            .padding(.horizontal)
            .padding(.top, vertical == .compact ? 2 : 8)
            .padding(.bottom, 2)
        }
        .background(.ultraThinMaterial)
    }
}
