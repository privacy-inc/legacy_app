import SwiftUI
import Specs

extension Landing.Edit {
    struct Content: View {
        @State private var cards = [Specs.Card]()
        @State private var mode = EditMode.active
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            NavigationView {
                List {
                    ForEach(cards) {
                        Item(active: $0.state, id: $0.id)
                    }
                    .onMove { index, destination in
                        guard let index = index.first else { return }
                        
                        Task
                            .detached(priority: .utility) {
                                await cloud.move(card: cards[index].id, index: destination)
                            }
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: .mint))
                .font(.callout)
                .imageScale(.large)
                .symbolRenderingMode(.multicolor)
                .listStyle(.plain)
                .navigationTitle("Configure")
                .navigationBarTitleDisplayMode(.inline)
                .environment(\.editMode, $mode)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Done")
                                .font(.callout)
                                .foregroundColor(.init("Shades"))
                                .padding(.leading)
                                .frame(height: 34)
                                .allowsHitTesting(false)
                                .contentShape(Rectangle())
                        }
                    }
                }
            }
            .navigationViewStyle(.stack)
            .onReceive(cloud) {
                cards = $0.cards
            }
        }
    }
}
