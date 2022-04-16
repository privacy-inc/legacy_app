import SwiftUI
import Specs

struct Tabs: View {
    @ObservedObject var session: Session
    @State private var items = [[Session.Item]]()
    @Namespace private var animation
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                if items.first?.isEmpty == true {
                    Text("No tabs open")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .padding(.top)
                        .padding(.leading, 30)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                } else {
                    Button("Close all") {
                        session.items = []
                        withAnimation(.easeInOut(duration: 0.4)) {
                            update(tabs: [])
                        }
                    }
                    .font(.footnote)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .tint(.secondary)
                    .foregroundStyle(.secondary)
                    .padding()
                    
                    HStack(alignment: .top, spacing: 9) {
                        ForEach(0 ..< items.count, id: \.self) { index in
                            VStack {
                                if items[index].isEmpty {
                                    Spacer()
                                        .frame(maxWidth: .greatestFiniteMagnitude)
                                } else {
                                    ForEach(items[index]) { item in
                                        Item(session: session, item: item) {
                                            session.items.remove { $0.id == item.id }
                                            
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                update(tabs: session.items)
                                            }
                                        }
                                        .matchedGeometryEffect(id: item.id, in: animation)
                                        .transition(.offset())
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical)
                }
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
                        let item = Session.Item(flow: .search(true))
                        session.items.append(item)
                        
                        withAnimation(.easeInOut(duration: 0.4)) {
                            session.current = .item(item.id)
                        }
                    }),
                trailing:
                    .init(icon: "flame", action: {
                        
                    }),
                material: .ultraThin)
        }
        .onAppear {
            update(tabs: session.items)
        }
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
