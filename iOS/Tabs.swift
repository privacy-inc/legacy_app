import SwiftUI
import Specs

struct Tabs: View {
    @ObservedObject var session: Session
    @State private var items = [[Session.Item]]()
    @State private var trackers = 0
    @State private var settings = false
    @State private var forget = false
    @State private var selected: Session.Item?
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 5) {
                        if items.first?.isEmpty == false {
                            HStack {
                                Button("Close tabs") {
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
                                .padding([.top, .leading], 20)
                                Spacer()
                            }
                        }
                        
                        Text(trackers, format: .number)
                            .font(.system(size: 40, weight: .thin))
                            .padding(.top, 30)
                        HStack {
                            Image(systemName: "bolt.shield")
                                .font(.system(size: 25, weight: .thin))
                            Text("Trackers prevented")
                                .font(.callout)
                        }
                        .foregroundStyle(.secondary)
                    }
                    .padding(.bottom, 35)
                    
                    if items.first?.isEmpty == true {
                        Label("No tabs", systemImage: "square.dashed")
                            .matchedGeometryEffect(id: "close", in: animation)
                            .font(.callout)
                            .imageScale(.large)
                            .foregroundStyle(.secondary)
                            .padding([.top, .leading], 20)
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    } else {
                        HStack(alignment: .top, spacing: 9) {
                            ForEach(0 ..< items.count, id: \.self) { index in
                                VStack {
                                    if items[index].isEmpty {
                                        Spacer()
                                            .frame(maxWidth: .greatestFiniteMagnitude)
                                    } else {
                                        ForEach(items[index]) { item in
                                            Item(selected: $selected, session: session, item: item, animation: animation) {
                                                session.items.remove { $0.id == item.id }
                                                
                                                withAnimation(.easeInOut(duration: 0.3)) {
                                                    update(tabs: session.items)
                                                }
                                            }
                                            .matchedGeometryEffect(id: "item.\(item.id)", in: animation)
                                            .transition(.offset())
                                            .id(item.id)
                                        }
                                    }
                                }
                                
                            }
                        }
                        .padding(.horizontal, 9)
                        .padding(.vertical)
                    }
                }
                .task {
                    proxy.scrollTo(session.items[session.previous % 2 == 1 ? session.previous - 1 : session.previous].id)
                }
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
            
            if let selected = selected {
                Image(uiImage: selected.thumbnail)
                    .resizable()
                    .matchedGeometryEffect(id: "image.\(selected.id)", in: animation)
                    .background(.ultraThickMaterial)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Bar(items: [
                .init(size: 17, icon: "line.3.horizontal") {
                    settings = true
                },
                .init(size: 20, icon: "plus") {
                    let item = Session.Item(flow: .search(true))
                    session.items.append(item)
                    
                    withAnimation(.easeInOut(duration: 0.4)) {
                        session.current = session.items.count - 1
                    }
                },
                .init(size: 20, icon: "flame") {
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
            
            if session.items[session.previous].flow == .web,
               session.items[session.previous].web != nil {
                selected = session.items[session.previous]
                withAnimation(.easeInOut(duration: 0.35)) {
                    selected = nil
                }
            }
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
