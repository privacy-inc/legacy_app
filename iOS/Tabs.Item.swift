import SwiftUI
import Specs

extension Tabs {
    struct Item: View {
        let item: Status.Item
        let open: () -> Void
        let close: () -> Void
        @State private var access: AccessType?
        @State private var publisher: Favicon.Pub?
        
        var body: some View {
            ZStack {
                VStack {
                    HStack {
                        if let publisher = publisher {
                            Icon(access: access!, publisher: publisher)
                        } else {
                            Image(systemName: "bolt.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.init("Dawn"))
                                .font(.title)
                        }
                        Spacer()
                        Button(action: close) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2.weight(.light))
                                .foregroundStyle(.secondary)
                                .symbolRenderingMode(.hierarchical)
                                .allowsHitTesting(false)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 160)
                    
                    Text(verbatim: item.error?.description ?? item.web?.title ?? "")
                        .font(.caption2)
                        .lineLimit(1)
                        .frame(width: 120)
                        .allowsHitTesting(false)
                }
                Button(action: open) {
                    Snap(image: item.image, size: 150)
                        .id(item.id)
                }
                .frame(height: 150)
            }
            .fixedSize()
            .task {
                guard let history = item.history else { return }
                access = await cloud.website(history: history)?.access
                if let access = access {
                    publisher = await favicon.publisher(for: access)
                }
            }
        }
    }
}
