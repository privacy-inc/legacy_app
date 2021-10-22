import SwiftUI
import Specs

struct Trackers: View {
    @State private var report = [Events.Report]()
    @State private var count = 0
    
    var body: some View {
        List {
            VStack(alignment: .leading) {
                Label("\(Text("Trackers").foregroundColor(.primary))", systemImage: "shield.lefthalf.filled")
                    .font(.headline)
                    .foregroundStyle(Color("Shades"))
                    .symbolRenderingMode(.palette)
                Text(count.formatted() + " prevented")
                    .font(.caption2.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical)
            .listRowBackground(Color.clear)
            .allowsHitTesting(false)
            
            ForEach(report) { item in
                VStack(alignment: .leading) {
                    Text(verbatim: item.website + " ")
                        .foregroundColor(.primary)
                        .font(.callout.bold())
                    
                    Text(verbatim: item.description)
                        .foregroundColor(.secondary)
                        .font(.caption2.monospacedDigit())
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

private extension Events.Report {
    var description: String {
         count + " — " + time
    }
    
    private var count: String {
        trackers.count.formatted() + (trackers.count == 1 ? " tracker" : " trackers")
    }
    
    private var time: String {
        date.formatted(.relative(presentation: .named, unitsStyle: .narrow))
    }
}
