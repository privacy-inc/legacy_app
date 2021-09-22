import SwiftUI

extension Landing {
    struct Bar: View {
        @Environment(\.verticalSizeClass) private var vertical
        
        var body: some View {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.primary.opacity(0.05))
                    .frame(height: 1)
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "gear")
                            .symbolRenderingMode(.hierarchical)
                            .padding(.leading)
                    }
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.regularMaterial)
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.primary.opacity(0.1))
                        Text("\(Image(systemName: "magnifyingglass")) Search or enter website")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.leading)
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    }
                    .frame(width: 220, height: 34)
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "square.on.square.dashed")
                            .symbolRenderingMode(.hierarchical)
                            .padding(.trailing)
                    }
                }
                .padding(vertical == .compact ? 2 : 16)
            }
            .background(.ultraThinMaterial)
        }
    }
}
