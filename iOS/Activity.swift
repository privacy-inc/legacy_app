import SwiftUI
import Specs

struct Activity: View {
    @State private var date: Date?
    @State private var timeline = [Double]()
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Timeline(values: timeline)
                        .frame(height: 180)
                    if let date = date {
                        HStack {
                            Text(verbatim: date.formatted(.relative(presentation: .named, unitsStyle: .wide)))
                            Spacer()
                            Text("Now")
                        }
                        .foregroundStyle(.tertiary)
                        .font(.caption)
                        .padding(.horizontal, 7)
                    }
                }
                .padding()
                .modifier(Card())
                .padding(.horizontal)
            }
            .padding(.vertical)
            .allowsHitTesting(false)
        }
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background(.ultraThickMaterial)
        .navigationTitle("Activity")
        .navigationBarTitleDisplayMode(.large)
        .onReceive(cloud) {
            date = $0.events.since
            timeline = $0.events.stats.timeline
        }
    }
}
