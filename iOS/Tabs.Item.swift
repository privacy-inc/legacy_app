import SwiftUI
import Specs

extension Tabs {
    struct Item: View {
        let status: Status
        let animating: Namespace.ID
        let entering: Bool
        let open: () -> Void
        let close: () -> Void
        @State private var access: AccessType?
        @State private var publisher: Favicon.Pub?
        
        var body: some View {
            VStack(spacing: 0) {
                Button(action: close) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2.weight(.light))
                        .foregroundStyle(.secondary)
                        .symbolRenderingMode(.hierarchical)
                        .allowsHitTesting(false)
                }
                .padding(.bottom, 20)
                
                Button(action: open) {
                    VStack(spacing: 0) {
                        Snap(image: status.image, size: 150)
                            .matchedGeometryEffect(id: status.id, in: animating, properties: .position, isSource: entering)
                            .id(status.id)
                        Text(verbatim: status.web?.title ?? "New")
                            .font(.caption2)
                            .lineLimit(1)
                            .padding(.horizontal)
                            .padding(.top, 12)
                            .padding(.bottom, 8)
                        Group {
                            if let publisher = publisher {
                                Icon(access: access!, publisher: publisher)
                            } else {
                                Image(systemName: "bolt.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundColor(.init("Shades"))
                                    .font(.title3)
                            }
                        }
                        .frame(width: 32, height: 32)
                    }
                    .frame(width: 150)
                    .allowsHitTesting(false)
                }
            }
            .task {
                guard let history = status.history else { return }
                access = await cloud.website(history: history).access
                publisher = await favicon.publisher(for: access!)
            }
        }
    }
}
