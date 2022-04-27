import SwiftUI

struct Downloads: View {
    @ObservedObject var session: Session
    
    var body: some View {
        ForEach(session.downloads, id: \.self.download) {
            Item(session: session, download: $0.download, status: $0.status)
                .padding(.top, 8)
            Divider()
                .padding(.horizontal)
                .padding(.bottom, 8)
        }
        Button {
            session.downloads = []
            try? FileManager.default.removeItem(at: .init(fileURLWithPath: NSTemporaryDirectory()))
        } label: {
            Text("Clear")
                .font(.callout)
                .padding(.horizontal, 4)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
        .foregroundColor(.secondary)
        .tint(.primary.opacity(0.2))
        .padding(.vertical, 8)
    }
}
