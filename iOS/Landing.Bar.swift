import SwiftUI

extension Landing {
    struct Bar: View {
        let tabs: () -> Void
        let search: () -> Void
        @State private var offset = CGFloat(100)
        @Environment(\.verticalSizeClass) private var vertical
        
        var body: some View {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(HierarchicalShapeStyle.quaternary)
                    .frame(height: 0.5)
                    .edgesIgnoringSafeArea(.horizontal)
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "gear")
                            .symbolRenderingMode(.hierarchical)
                            .padding(.horizontal)
                    }
                    Spacer()
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
            .offset(y: offset)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.4)) {
                    offset = 0
                }
            }
        }
    }
}
