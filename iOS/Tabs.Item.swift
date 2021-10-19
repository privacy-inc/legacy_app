import SwiftUI
import Specs

extension Tabs {
    struct Item: View {
        let item: Status.Item
        let selected: Bool
        let open: () -> Void
        let close: () -> Void
        @State private var access: AccessType?
        @State private var publisher: Favicon.Pub?
        
        var body: some View {
            Button(action: open) {
                VStack(spacing: 12) {
                    if !selected {
                        if let publisher = publisher {
                            Icon(access: access!, publisher: publisher)
                        } else {
                            Image(systemName: "globe")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.quaternary)
                                .font(.title)
                        }
                    }
                    
                    ZStack(alignment: .topTrailing) {
                        container
                            .fill(.ultraThickMaterial)
                            .frame(width: size, height: size)
                            .shadow(color: .primary.opacity(0.1), radius: 5)
                            .allowsHitTesting(false)
                        container
                            .stroke(Color(.systemBackground), style: .init(lineWidth: 2))
                            .frame(width: size, height: size)
                            .allowsHitTesting(false)
                        
                        Image(uiImage: item.image ?? .blank)
                            .resizable()
                            .scaledToFill()
                            .frame(width: size, height: size)
                            .clipShape(container)
                            .allowsHitTesting(false)
                        
                        if size != nil {
                            Button(action: close) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title.weight(.light))
                                    .foregroundStyle(Color(.systemBackground), Color.secondary)
                                    .symbolRenderingMode(.palette)
                                    .allowsHitTesting(false)
                            }
                        }
                    }
                    .id(item.id)
                    
                    if !selected {
                        Text(verbatim: item.error?.description ?? item.web?.title ?? "")
                            .font(.caption2.weight(.light))
                            .lineLimit(1)
                            .frame(width: 135)
                            .allowsHitTesting(false)
                    }
                }
            }
            .task {
                guard let history = item.history else { return }
                access = await cloud.website(history: history)?.access
                if let access = access {
                    publisher = await favicon.publisher(for: access)
                }
            }
        }
        
        private var size: CGFloat? {
            selected ? nil : 150
        }
        
        private let container = RoundedRectangle(cornerRadius: 10, style: .continuous)
    }
}
