import SwiftUI

extension Landing {
    struct Bar: View {
        let tabs: () -> Void
        let search: () -> Void
        @Environment(\.verticalSizeClass) private var vertical
        
        var body: some View {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.primary.opacity(0.05))
                    .frame(height: 1)
                    .edgesIgnoringSafeArea(.horizontal)
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "gear")
                            .symbolRenderingMode(.hierarchical)
                            .padding(.horizontal)
                    }
                    Spacer()
                    Button(action: search) {
                        ZStack {
                            Circle()
                                .fill(.regularMaterial)
                                .frame(width: 38, height: 38)
                                .shadow(color: .primary.opacity(0.1), radius: vertical == .compact ? 0 : 3)
                            Circle()
                                .stroke(Color(.systemBackground))
                                .frame(width: 38, height: 38)
                            Image(systemName: "magnifyingglass")
                                .font(.caption)
                                .foregroundStyle(.primary)
                        }
                        .fixedSize()
                    }
                    Spacer()
                    Button(action: tabs) {
                        Image(systemName: "square.on.square.dashed")
                            .symbolRenderingMode(.hierarchical)
                            .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
                .padding(.top, vertical == .compact ? 2 : 8)
                .padding(.bottom, 2)
            }
            .background(.ultraThinMaterial)
        }
    }
}
