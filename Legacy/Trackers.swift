//import SwiftUI
//import Specs
//
//struct Trackers: View {
//    @State private var report = [Events.Report]()
//    @State private var count = 0
//    
//    var body: some View {
//        List(report) { item in
//            Section {
//                ForEach(item.trackers, id: \.self) {
//                    Text(verbatim: $0)
//                        .font(.callout)
//                        .foregroundStyle(.secondary)
//                }
//            } header: {
//                HStack {
//                    Icon(icon: item.website.lowercased())
//                    Text(verbatim: item.date.formatted(.relative(presentation: .named, unitsStyle: .wide)) + "\n")
//                        .foregroundColor(.secondary)
//                        .font(.caption)
//                    + Text(verbatim: item.website)
//                        .foregroundColor(.primary)
//                        .font(.body.bold())
//                    Spacer()
//                    Text(item.trackers.count, format: .number)
//                        .foregroundColor(.primary)
//                        .font(.callout.monospaced())
//                    + Text(item.trackers.count == 1 ? " tracker" : " trackers")
//                        .foregroundColor(.secondary)
//                        .font(.callout)
//                }
//                .padding(.vertical, 10)
//            }
//        }
//        .listStyle(.plain)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Group {
//                    Text(count, format: .number)
//                        .foregroundColor(.primary)
//                        .font(.callout.monospaced())
//                    + Text(count == 1 ? " tracker so far" : " total trackers")
//                        .foregroundColor(.secondary)
//                        .font(.callout)
//                }
//            }
//        }
//        .navigationTitle("Trackers")
//        .navigationBarTitleDisplayMode(.large)
//        .onReceive(cloud) {
//            count = $0.events.prevented
//            report = $0
//                .events
//                .report
//                .filter {
//                    !$0.trackers.isEmpty
//                }
//        }
//    }
//}
