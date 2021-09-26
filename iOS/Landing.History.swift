import SwiftUI
import Specs

extension Landing {
    struct History: View {
        @State private var history = [Specs.History]()
        @State private var items = [[Specs.History]]()
        @Environment(\.verticalSizeClass) private var vertical
        
        var body: some View {
            Section("History") {
                HStack(alignment: .top) {
                    ForEach(0 ..< items.count, id: \.self) { index in
                        VStack {
                            ForEach(items[index], content: Item.init)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                update(with: vertical)
            }
            .onChange(of: vertical, perform: update(with:))
            .onReceive(cloud) {
                history = $0.history
                update(with: vertical)
            }
        }
        
        private func update(with vertical: UserInterfaceSizeClass?) {
            items = (vertical == .compact ? 3 : 2)
                .columns(with: 3)
                .reduce(into: .init()) { result, position in
                    if history.count > position.index {
                        if position.row == 0 {
                            result.append(.init())
                        }
                        result[position.col].append(history[position.index])
                    }
                }
        }
    }
    
    private struct Item: View {
        let item: Specs.History
        
        var body: some View {
            Button {
                
            } label: {
                Text("\(Image("")) \(Text(item.website.title))\n\(Text(item.website.access.value).foregroundColor(.secondary).font(.caption2))")
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding()
                    .modifier(Card())
            }
        }
    }
}
