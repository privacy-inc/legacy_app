import SwiftUI
import Specs

struct Activity: View {
    @State private var date: Date?
//    @State private var stats: Events.Stats?
    @State private var prevented = 0
    
    var body: some View {
        List {
//            Label("Activity", systemImage: "chart.xyaxis.line")
//                .font(.headline)
//                .symbolRenderingMode(.palette)
//                .foregroundStyle(Color.primary, Color("Dawn"))
//                .listRowBackground(Color.clear)
//            if let stats = stats {
//                Timeline(values: stats.timeline)
//                    .frame(height: 100)
//                    .allowsHitTesting(false)
//
//                if let date = date {
//                    HStack {
//                        Text(verbatim: date.formatted(.relative(presentation: .named, unitsStyle: .wide)))
//                        Spacer()
//                        Text("Now")
//                    }
//                    .foregroundStyle(.secondary)
//                    .font(.caption2)
//                    .listRowBackground(Color.clear)
//                    .allowsHitTesting(false)
//                }
//
//                VStack(alignment: .leading) {
//                    Text("Total events")
//                        .font(.caption2)
//                        .foregroundStyle(.secondary)
//                    Text(stats.websites, format: .number)
//                        .font(.footnote)
//                        .foregroundStyle(.primary)
//                }
//                .listRowBackground(Color.clear)
//                .allowsHitTesting(false)
//
//                VStack(alignment: .leading) {
//                    Text("Tracker events")
//                        .font(.caption2)
//                        .foregroundStyle(.secondary)
//                    Text(prevented, format: .number)
//                        .font(.footnote)
//                        .foregroundStyle(.primary)
//                }
//                .listRowBackground(Color.clear)
//                .allowsHitTesting(false)
//
//                if let domains = stats.domains {
//                    VStack(alignment: .leading) {
//                        Text("Total websites")
//                            .font(.caption2)
//                            .foregroundStyle(.secondary)
//                        Text(domains.count, format: .number)
//                            .font(.footnote)
//                            .foregroundStyle(.primary)
//                    }
//                    .listRowBackground(Color.clear)
//                    .allowsHitTesting(false)
//
//                    VStack(alignment: .leading) {
//                        Text("Most visited")
//                            .font(.caption2)
//                            .foregroundStyle(.secondary)
//                        Text(verbatim: domains.top)
//                            .font(.footnote)
//                            .foregroundStyle(.primary)
//                    }
//                    .listRowBackground(Color.clear)
//                    .allowsHitTesting(false)
//                }
//
//                if let trackers = stats.trackers {
//                    VStack(alignment: .leading) {
//                        Text("Total trackers")
//                            .font(.caption2)
//                            .foregroundStyle(.secondary)
//                        Text(trackers.count, format: .number)
//                            .font(.footnote)
//                            .foregroundStyle(.primary)
//                    }
//                    .listRowBackground(Color.clear)
//                    .allowsHitTesting(false)
//
//                    VStack(alignment: .leading) {
//                        Text("Most prevented")
//                            .font(.caption2)
//                            .foregroundStyle(.secondary)
//                        Text(verbatim: trackers.top)
//                            .font(.footnote)
//                            .foregroundStyle(.primary)
//                    }
//                    .listRowBackground(Color.clear)
//                    .allowsHitTesting(false)
//                }
//            }
        }
        .ignoresSafeArea(edges: .top)
//        .onReceive(cloud) {
//            date = $0.events.since
//            prevented = $0.events.prevented
//            stats = $0.events.stats
//        }
    }
}
