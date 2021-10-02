import SwiftUI

extension Landing {
    struct Trackers: View {
        var body: some View {
            Button {
                
            } label: {
                Section("Trackers") {
                    HStack(spacing: 0) {
                        Text("\(Image(systemName: "shield.lefthalf.filled")) 199")
                            .monospacedDigit()
                        Text("Trackers prevented")
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                            .padding(.leading)
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    }
                    .padding()
                    .modifier(Card())
                    .padding(.horizontal)
                }
            }
        }
    }
}
