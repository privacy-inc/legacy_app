import SwiftUI
import Specs

struct Trackers: View {
    @State private var trackers = 0
    
    var body: some View {
        VStack(spacing: 10) {
            Text(trackers, format: .number)
                .font(.system(size: 40, weight: .light))
            HStack {
                Image(systemName: "bolt.shield")
                    .font(.system(size: 30, weight: .thin))
                Text("Trackers\nprevented")
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .foregroundStyle(.secondary)
        }
        .onReceive(cloud) {
            trackers = $0.tracking.total
        }
    }
}
