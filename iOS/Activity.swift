import SwiftUI
import Specs

struct Activity: View {
    @State private var date: Date?
    @State private var timeline = [Double]()
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Chart(values: timeline)
                        .frame(height: 180)
                        .padding(.horizontal)
                        .padding(.bottom)
                    if let date = date {
                        HStack {
                            Text(verbatim: date.formatted(.relative(presentation: .named, unitsStyle: .wide)))
                            Spacer()
                            Text("Now")
                        }
                        .foregroundStyle(.tertiary)
                        .font(.caption)
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
