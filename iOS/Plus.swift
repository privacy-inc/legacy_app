import SwiftUI

struct Plus: View {
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    Banner()
                        .frame(width: 250, height: 250)
                    Spacer()
                }
            }
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Privacy Plus")
        .navigationBarTitleDisplayMode(.inline)
    }
}
