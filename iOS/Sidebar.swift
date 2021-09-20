import SwiftUI

struct Sidebar: View {
    var body: some View {
        List {
            NavigationLink(destination: Tabs()) {
                Text("Tabs")
            }
            Text("world")
        }
        .listStyle(.insetGrouped)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Menu")
    }
}
