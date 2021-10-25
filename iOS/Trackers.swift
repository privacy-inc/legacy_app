import SwiftUI
import Specs

struct Trackers: View {
    @State private var report = [Events.Report]()
    @State private var count = 0
    
    var body: some View {
        List(report) { item in
            Section {
                ForEach(item.trackers, id: \.self) {
                    Text(verbatim: $0)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            } header: {
                HStack {
                    Icon(icon: item.website)
                    Text(verbatim: item.time + "\n")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    + Text(verbatim: item.website)
                        .foregroundColor(.primary)
                        .font(.body.bold())
                    Spacer()
                    Text(verbatim: item.count)
                        .foregroundColor(.primary)
                        .font(.callout.monospacedDigit())
                }
                .padding(.vertical, 10)
            }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text(count.formatted() + " trackers")
                    .font(.callout.monospacedDigit())
                    .foregroundStyle(.primary)
            }
        }
        .navigationTitle("Trackers")
        .navigationBarTitleDisplayMode(.large)
        .onReceive(cloud) {
            count = $0.events.prevented
            report = $0
                .events
                .report
                .filter {
                    !$0.trackers.isEmpty
                }
        }
    }
}

private extension Events.Report {
    var count: String {
        trackers.count.formatted() + (trackers.count == 1 ? " tracker" : " trackers")
    }
    
    var time: String {
        date.formatted(.relative(presentation: .named, unitsStyle: .wide))
    }
}
