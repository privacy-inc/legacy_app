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
            Divider()
                .ignoresSafeArea(edges: .horizontal)
            HStack(spacing: 0) {
                leading
                    .foregroundStyle(.secondary)
                Button {
                    search()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(vertical == .compact ? .body : .title2)
                        .frame(width: 34, height: 34)
                        .allowsHitTesting(false)
                }
                .foregroundStyle(.secondary)
                trailing
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .padding(.top, vertical == .compact ? 0 : 10)
            .padding(.bottom, 2)
        }
        .background(.thinMaterial)
    }
}
