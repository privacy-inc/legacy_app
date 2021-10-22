import SwiftUI

struct Forget: View {
    var body: some View {
        List {
            Label("\(Text("Forget").foregroundColor(.primary))", systemImage: "flame.fill")
                .font(.headline)
                .foregroundStyle(Color("Dawn"))
                .listRowBackground(Color.clear)
            
            Item(title: "History",
                 icon: "clock",
                 primary: .primary,
                 secondary: .init("Shades")) {
                await cloud.forgetHistory()
            }
            
            Item(title: "Activity",
                 icon: "chart.xyaxis.line",
                 primary: .primary,
                 secondary: .init("Dawn")) {
                await cloud.forgetActivity()
            }
            
            Item(title: "Everything",
                 icon: "flame",
                 primary: .init("Dawn"),
                 secondary: .primary) {
                await cloud.forget()
            }
        }
        .ignoresSafeArea(edges: .top)
        .symbolRenderingMode(.palette)
    }
}
