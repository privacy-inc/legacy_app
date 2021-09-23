import SwiftUI

extension Landing {
    struct Bookmarks: View {
        @State private var items = [[Model]]()
        @Environment(\.verticalSizeClass) private var vertical
        
        var body: some View {
            Section("Bookmarks") {
                HStack(alignment: .top) {
                    ForEach(0 ..< items.count, id: \.self) { index in
                        VStack {
                            ForEach(items[index], content: Item.init)
                        }
                    }
                }
            }
            .onAppear {
                update(with: vertical)
            }
            .onChange(of: vertical, perform: update(with:))
        }
        
        private func update(with vertical: UserInterfaceSizeClass?) {
            items = (vertical == .compact ? 5 : 4)
                .columns(with: 2)
                .reduce(into: .init()) { result, position in
                    if bookmarks.count > position.index {
                        if position.row == 0 {
                            result.append(.init())
                        }
                        result[position.col].append(bookmarks[position.index])
                    }
                }
        }
    }
    
    private struct Item: View {
        let model: Model
        
        var body: some View {
            Button {
                
            } label: {
                VStack {
                    Image(model.icon)
                        .padding(8)
                        .modifier(Card())
                    Text(verbatim: model.title)
                        .font(.caption2)
                        .lineLimit(2)
                        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .top)
                        .padding(.horizontal)
                }
                .frame(height: 100)
            }
        }
    }
}

private let bookmarks = [
    Model(title: "Alan Moore - Wikipedia"),
    .init(title: "Alan Moore - Google"),
    .init(title: "A"),
    .init(title: "Alan Moore - Google"),
    .init(title: "Alan Moore - Wikipedia"),
    .init(title: "Reuters"),
    .init(title: "Alan Moore - Wikipedia lorem ips"),
    .init(title: "r"),
    .init(title: "dsda"),
    .init(title: "Alan Moore - Wikipedia lorem ips dasddasdasa"),
    .init(title: "fdsfsd"),
    .init(title: "535354334"),
    .init(title: "popopodas adsasdas")
]

private struct Model: Identifiable {
    let id = UUID()
    let icon = "favicon"
    let title: String
}
