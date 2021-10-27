import SwiftUI

struct Tabs: View {
    @Binding var status: Status
    @State private var offset = CGFloat()
    @State private var create = false
    @State private var hide = false
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    if !hide {
                        Spacer()
                            .frame(width: 30)
                            .frame(maxHeight: .greatestFiniteMagnitude)
                    }
                    ForEach(hide ? [status.item!] : status.items) { item in
                        Item(item: item, selected: item.id == status.item?.id) {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                hide = true
                                status.index = status
                                    .items
                                    .firstIndex {
                                        $0.id == item.id
                                    }!
                            }
                            
                            DispatchQueue
                                .main
                                .asyncAfter(deadline: .now() + 0.3) {
                                    status.tab()
                                }
                        } close: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                status
                                    .items
                                    .remove {
                                        $0.id == item.id
                                    }?
                                    .web?
                                    .clear()
                            }
                        }
                    }
                    if !hide {
                        Spacer()
                            .frame(width: 30)
                            .frame(maxHeight: .greatestFiniteMagnitude)
                    }
                }
            }
            .background(LinearGradient(gradient: .init(colors: [.clear, .primary.opacity(0.2)]), startPoint: .bottom, endPoint: .top))
            .ignoresSafeArea(edges: .all)
            .task {
                status
                    .item
                    .map {
                        proxy.scrollTo($0.id, anchor: .center)
                    }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if status.index == nil && !create {
                ZStack {
                    HStack {
                        Button {
                            status
                                .items
                                .forEach {
                                    $0
                                        .web?
                                        .clear()
                                }
                            
                            withAnimation(.easeInOut(duration: 0.3)) {
                                status.items = []
                            }
                        } label: {
                            Text("Close all")
                                .foregroundStyle(status.items.isEmpty ? .tertiary : .primary)
                                .frame(height: 34)
                                .contentShape(Rectangle())
                                .allowsHitTesting(false)
                        }
                        .disabled(status.items.isEmpty)
                        
                        Spacer()
                        
                        Group {
                            Text(status.items.count, format: .number)
                                .font(.callout.monospaced())
                            Text(status.items.count == 1 ? "tab" : "tabs")
                        }
                        .foregroundStyle(status.items.isEmpty ? .tertiary : .secondary)
                        .allowsHitTesting(false)
                    }
                    .font(.callout)
                    .padding(.horizontal)
                    Button {
                        offset = UIScreen.main.bounds.height
                        create = true
                        
                        withAnimation(.easeInOut(duration: 0.35)) {
                            offset = 0
                        }

                        DispatchQueue
                            .main
                            .asyncAfter(deadline: .now() + 0.35) {
                                status.add()
                            }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle.weight(.light))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.init("Shades"))
                            .shadow(color: .init("Shades"), radius: 10)
                            .allowsHitTesting(false)
                    }
                }
                .padding([.leading, .trailing, .bottom])
            }
            if create {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.tertiary)
                    .font(.largeTitle)
                    .frame(height: UIScreen.main.bounds.height)
                    .frame(maxWidth: .greatestFiniteMagnitude)
                    .ignoresSafeArea(edges: .all)
                    .background(Color(.secondarySystemBackground))
                    .shadow(color: .primary.opacity(0.4), radius: 30)
                    .offset(y: offset)
                    .allowsHitTesting(false)
            }
        }
        .task {
            withAnimation(.easeInOut(duration: 0.35)) {
                status.index = nil
            }
        }
    }
}
