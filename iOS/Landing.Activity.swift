import SwiftUI

extension Landing {
    struct Activity: View {
        @State private var date = Date.now
        
        var body: some View {
            Button {
                
            } label: {
                Section("Activity") {
                    HStack {
                        Label("Since", systemImage: "chart.xyaxis.line")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.primary, Color("Dawn"))
                            .imageScale(.large)
                            .font(.callout)
                        Text(verbatim: date.formatted(.relative(presentation: .named, unitsStyle: .wide)))
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    }
                    .padding()
                    .modifier(Card())
                    .padding(.horizontal)
                }
                .allowsHitTesting(false)
            }
            .onReceive(cloud) {
                date = $0
                    .events
                    .timestamps
                    .first
                    .map(Date.init(timestamp:))
                ?? .now
            }
        }
    }
}
