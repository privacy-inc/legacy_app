import SwiftUI

extension Landing {
    struct Activity: View {
        var body: some View {
            Button {
                
            } label: {
                Header("Activity") {
                    HStack(spacing: 0) {
                        Image(systemName: "chart.xyaxis.line")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color("Shades"), Color("Dawn"))
                        Text("Activity in the last 3 weeks")
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
