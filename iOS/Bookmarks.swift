import SwiftUI
import Specs

struct Bookmarks: View {
    @Binding var presented: Bool
    let select: (URL) -> Void
    @State private var items = [Website]()
    
    var body: some View {
        List {
            ForEach(items) { item in
                Listed(item: item) {
                    presented = false
                    item
                        .access
                        .url
                        .map {
                            select($0)
                        }
                }
            }
            .onDelete { index in
                
            }
            .onMove { index, destination in
                
            }
        }
        .listStyle(.insetGrouped)
        .toolbar {
            EditButton()
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Bookmarks")
        .navigationBarTitleDisplayMode(.large)
        .onReceive(cloud) {
            items = $0.bookmarks
        }
    }
}
