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
                    Text(verbatim: item.website + " ")
                        .foregroundColor(.primary)
                        .font(.body.bold())
                    Spacer()
                    Text(verbatim: item.description)
                        .foregroundColor(.secondary)
                        .font(.footnote.monospacedDigit())
                }
                .padding(.vertical, 8)
            }
            .listRowBackground(Color(.secondarySystemBackground))
            .listSectionSeparator(.hidden)
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text(count.formatted() + " prevented")
                    .font(.callout.monospacedDigit())
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

private extension Events.Report {
    var description: String {
         count + " — " + time
    }
    
    private var count: String {
        trackers.count.formatted() + (trackers.count == 1 ? " tracker" : " trackers")
    }
    
    private var time: String {
        date.formatted(.relative(presentation: .named, unitsStyle: .wide))
    }
}
