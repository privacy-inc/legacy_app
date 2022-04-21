import SwiftUI
import Specs

struct Tabs: View {
    @ObservedObject var session: Session
    @State private var items = [[Session.Item]]()
    @State private var trackers = 0
    @State private var settings = false
    @State private var forget = false
    @Namespace private var animation
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 8) {
                    Text(trackers, format: .number)
                        .font(.system(size: 32, weight: .light))
                        .padding(.top, 30)
                    HStack {
                        Image(systemName: "bolt.shield")
                            .font(.system(size: 20, weight: .thin))
                        Text("Trackers prevented")
                            .font(.footnote)
                    }
                    .foregroundStyle(.secondary)
                }
                .padding(.bottom)
                
                if items.first?.isEmpty == true {
                    Label("No tabs", systemImage: "square.dashed")
                        .matchedGeometryEffect(id: "close", in: animation)
                        .font(.callout)
                        .imageScale(.large)
                        .foregroundStyle(.secondary)
                        .padding([.top, .leading], 30)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                } else {
                    Button("Close all tabs") {
                        session.items = []
                        withAnimation(.easeInOut(duration: 0.4)) {
                            update(tabs: [])
                        }
                    }
                    .matchedGeometryEffect(id: "close", in: animation)
                    .font(.footnote)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .tint(.secondary)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 30)
                    
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
            Bar(items: [
                .init(icon: "line.3.horizontal") {
                    settings = true
                },
                .init(icon: "plus") {
                    let item = Session.Item(flow: .search(true))
                    session.items.append(item)
                    
                    withAnimation(.easeInOut(duration: 0.4)) {
                        session.current = session.items.count - 1
                    }
                },
                .init(icon: "flame") {
                    forget = true
                }
            ],
                material: .ultraThin)
            .sheet(isPresented: $settings, content: Settings.init)
            .sheet(isPresented: $forget) {
                Forget(rootView: .init(items: $items, session: session))
            }
        }
        .onReceive(cloud) {
            trackers = $0.tracking.total
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
