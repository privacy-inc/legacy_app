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
                Group {
                    Text(verbatim: item.website + " ")
                        .foregroundColor(.primary)
                        .font(.body)
                    + Text(verbatim: item.date.formatted(.relative(presentation: .named, unitsStyle: .wide)))
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .padding(.vertical, 8)
            }
            .listRowBackground(Color(.secondarySystemBackground))
            .listSectionSeparator(.hidden)
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
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
