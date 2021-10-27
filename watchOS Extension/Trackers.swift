import SwiftUI
import Specs

struct Trackers: View {
    @State private var report = [Events.Report]()
    @State private var count = 0
    
    var body: some View {
        List {
            Label("\(Text("Trackers").foregroundColor(.primary))", systemImage: "shield.lefthalf.filled")
                .font(.headline)
                .foregroundStyle(Color("Shades"))
                .symbolRenderingMode(.palette)
                .listRowBackground(Color.clear)
                .allowsHitTesting(false)
            
            Group {
                Text(verbatim: count.formatted())
                    .font(.caption2.monospaced())
                + Text(" prevented")
                    .font(.caption2)
            }
            .foregroundStyle(.secondary)
            .listRowBackground(Color.clear)
            .allowsHitTesting(false)
            
            ForEach(report) { item in
                VStack(alignment: .leading) {
                    Text(verbatim: item.website + " ")
                        .foregroundColor(.primary)
                        .font(.callout.bold())
                    
                    Text(verbatim: item.trackers.count.formatted())
                        .foregroundColor(.secondary)
                        .font(.caption2.monospaced())
                    + Text(verbatim: item.trackers.count == 1 ? " tracker" : " trackers")
                        .foregroundColor(.secondary)
                        .font(.caption2)
                    
                    Text(verbatim: item.date.formatted(.relative(presentation: .named, unitsStyle: .narrow)))
                        .foregroundColor(.secondary)
                        .font(.caption2)
                }
                .allowsHitTesting(false)
                
                VStack(alignment: .leading) {
                    ForEach(item.trackers, id: \.self, content: Text.init(verbatim:))
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
                .listRowBackground(Color.clear)
                .allowsHitTesting(false)
            }
        }
        .ignoresSafeArea(edges: .top)
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
