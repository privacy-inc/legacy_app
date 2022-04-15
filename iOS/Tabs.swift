import SwiftUI
import Specs

struct Tabs: View {
    @ObservedObject var session: Session
    @State private var items = [[Session.Item]]()
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                HStack(alignment: .top) {
                    ForEach(0 ..< items.count, id: \.self) { index in
                        LazyVStack {
                            ForEach(items[index]) {
                                Item(session: session, item: $0)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .background(.ultraThickMaterial)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Bar(leading:
                    .init(icon: "line.3.horizontal", action: {
                        
                    }),
                center:
                    .init(icon: "plus", action: {

                    }),
                trailing:
                    .init(icon: "square.on.square", action: {
                        
                    }),
                material: .ultraThin)
        }
        .onAppear {
            update(tabs: session.items)
        }
        .onChange(of: session.items, perform: update(tabs:))
    }
    
    private func update(tabs: [Session.Item]) {
        items = tabs
            .reduce(into: .init(repeating: [Session.Item](), count: 2)) {
                if $0[0].count > $0[1].count {
                    $0[1].append($1)
                } else {
                    $0[0].append($1)
                }
            }
    }
}
