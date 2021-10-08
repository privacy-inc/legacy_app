import SwiftUI
import Specs

struct Bookmarks: View {
    @Binding var presented: Bool
    let select: (AccessType) -> Void
    @State private var items = [Website]()
    
    var body: some View {
        List {
            if items.isEmpty {
                Text("No bookmarks")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(items) { item in
                    Listed(item: item) {
                        presented = false
                        select(item.access)
                    }
                }
                .onDelete {
                    guard let index = $0.first else { return }
                    
                    Task
                        .detached(priority: .utility) {
                            await cloud.delete(bookmark: index)
                        }
                }
                .onMove { index, destination in
                    guard let index = index.first else { return }
                    
                    Task
                        .detached(priority: .utility) {
                            await cloud.move(bookmark: index, to: destination)
                        }
                }
            }
        }
        .listStyle(.insetGrouped)
        .toolbar {
            if !items.isEmpty {
                EditButton()
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Bookmarks")
        .navigationBarTitleDisplayMode(.large)
        .onReceive(cloud) {
            items = $0.bookmarks
        }
    }
}
