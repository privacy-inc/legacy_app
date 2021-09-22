import SwiftUI

extension Landing {
    struct Report: View {
        var body: some View {
            Button {
                
            } label: {
                Header("Trackers Report") {
                    HStack(spacing: 0) {
                        Text("\(Image(systemName: "shield.lefthalf.filled")) 199")
                            .monospacedDigit()
                        Text("Trackers report")
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
