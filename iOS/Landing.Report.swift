import SwiftUI

extension Landing {
    struct Report: View {
        var body: some View {
            Header("Report") {
                HStack(spacing: 0) {
                    Text("\(Image(systemName: "shield.lefthalf.filled")) 199")
                        .monospacedDigit()
                    Text("Privacy report")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                        .padding(.leading)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                .padding()
                .modifier(Card {
                    
                })
            }
        }
    }
}
