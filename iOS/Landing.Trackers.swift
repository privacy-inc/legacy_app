import SwiftUI

extension Landing {
    struct Trackers: View {
        @State private var count = 0
        @State private var display = false
        
        var body: some View {
            Button {
                display = true
            } label: {
                Section("Trackers") {
                    HStack {
                        Label(count.formatted(), systemImage: "shield.lefthalf.filled")
                            .font(.body.monospaced())
                        Text("Trackers prevented")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    }
                    .animation(.none, value: count)
                    .font(.callout)
                    .padding()
                    .modifier(Card())
                    .padding(.horizontal)
                }
                .allowsHitTesting(false)
            }
            .onReceive(cloud) {
                count = $0.events.prevented
            }
            .sheet(isPresented: $display) {
                Privacy.Trackers.Stand(display: $display)
            }
        }
    }
}
