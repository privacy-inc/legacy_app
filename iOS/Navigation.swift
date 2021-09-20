import SwiftUI

struct Navigation: View {
    var body: some View {
        NavigationView {
            Sidebar()
            Tab(id: .init())
        }
        .navigationViewStyle(.columns)
    }
}
