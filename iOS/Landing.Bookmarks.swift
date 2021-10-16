import SwiftUI
import Specs

extension Landing {
    struct Bookmarks: View {
        let select: (AccessType) -> Void
        @State private var bookmarks = [Website]()
        @State private var items = [[Website]]()
        @Environment(\.verticalSizeClass) private var vertical
        
        var body: some View {
            Section("Bookmarks") {
                HStack(alignment: .top) {
                    ForEach(0 ..< items.count, id: \.self) { index in
                        VStack {
                            ForEach(items[index]) {
                                Item(item: $0, select: select)
                            }
                        }
                    }
                }
            }
            .animation(.none, value: items.count)
            .onChange(of: vertical, perform: update(with:))
            .onReceive(cloud) {
                bookmarks = $0.bookmarks
                update(with: vertical)
            }
        }
        
        private func update(with vertical: UserInterfaceSizeClass?) {
            items = (vertical == .compact ? 5 : 3)
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
}
