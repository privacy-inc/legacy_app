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
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            } header: {
                VStack {
                    Text(verbatim: item.website)
                        .font(.title3)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    Text(verbatim: item.date.formatted(.relative(presentation: .named, unitsStyle: .wide)))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
            }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text(count.formatted() + " prevented")
                    .monospacedDigit()
                    .font(.callout)
                    .foregroundStyle(.secondary)
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
