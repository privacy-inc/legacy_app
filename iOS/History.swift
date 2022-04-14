//import SwiftUI
//import Specs
//
//struct History: View {
//    @Binding var presented: Bool
//    let select: (UInt16) -> Void
//    @State private var items = [Specs.History]()
//    
//    var body: some View {
//        List {
//            if items.isEmpty {
//                Text("No history")
//                    .font(.callout)
//                    .foregroundStyle(.secondary)
//                    .listRowSeparator(.hidden)
//                    .listRowBackground(Color.clear)
//            } else {
//                ForEach(items) { item in
//                    Listed(item: item.website) {
//                        presented = false
//                        select(item.id)
//                    }
//                }
//                .onDelete {
//                    guard let index = $0.first else { return }
//                    
//                    Task
//                        .detached(priority: .utility) {
//                            await cloud.delete(history: items[index].id)
//                        }
//                }
//            }
//        }
//        .listStyle(.grouped)
//        .toolbar {
//            if !items.isEmpty {
//                EditButton()
//                    .font(.callout)
//                    .foregroundStyle(.secondary)
//            }
//        }
//        .navigationTitle("History")
//        .navigationBarTitleDisplayMode(.large)
//        .onReceive(cloud) {
//            items = $0.history
//        }
//    }
//}
