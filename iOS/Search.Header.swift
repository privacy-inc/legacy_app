import SwiftUI

extension Search {
    struct Header: View {
        let tab: () -> Void
        @State private var offset = CGFloat(-100)
        @Environment(\.verticalSizeClass) private var vertical
        
        var body: some View {
            VStack(spacing: 0) {
                ZStack {
                    Image(systemName: "magnifyingglass")
                    Group {
                        Button(role: .cancel) {
                            UIApplication.shared.hide()
                            withAnimation(.easeInOut(duration: 0.4)) {
                                offset = -100
                            }
                            tab()
                        } label: {
                            Text("Cancel")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)
                                .padding(.vertical, 6)
                        }
                    }
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .trailing)
                }
                .padding(.top, 2)
                .padding(.bottom, vertical == .compact ? 0 : 6)
                
                Rectangle()
                    .fill(HierarchicalShapeStyle.quaternary)
                    .frame(height: 0.5)
                    .edgesIgnoringSafeArea(.horizontal)
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
