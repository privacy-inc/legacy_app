import SwiftUI
import Specs

struct Search: View {
    @ObservedObject var session: Session
    @State private var items = [[Website]]()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    ForEach(0 ..< items.count, id: \.self) { index in
                        VStack {
                            ForEach(items[index]) {
                                Text($0.id)
//                                    Item(item: $0, select: select)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .background(.ultraThickMaterial)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Bar(session: session,
                leading: (icon: "line.3.horizontal", action: {
                
            }),
                trailing: (icon: "square.on.square.dashed", action: {
                
            }))
        }
        .onReceive(cloud) {
            items = $0
                .websites(filter: "")
                .reduce(into: .init(repeating: [Website](), count: 2)) {
                    if $0[0].count > $0[1].count {
                        $0[1].append($1)
                    } else {
                        $0[0].append($1)
                    }
                }
//
//            (0 ..< self)
//                .flatMap { col in
//                    (0 ..< rows)
//                        .map { row in
//                            (col: col, row: row, index: col + (row * self))
//                        }
//                }
//
//
//            items = (2)
//                            .columns(with: 5)
//                            .reduce(into: .init()) { result, position in
//                                if history.count > position.index {
//                                    if position.row == 0 {
//                                        result.append(.init())
//                                    }
//                                    result[position.col].append(history[position.index])
//                                }
//                            }
        }
    }
}
