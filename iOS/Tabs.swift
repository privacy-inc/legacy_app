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
                            withAnimation(.easeInOut(duration: 0.4)) {
                                hide = true
                                status.index = status
                                    .items
                                    .firstIndex {
                                        $0.id == item.id
                                    }!
                            }
                            
                            DispatchQueue
                                .main
                                .asyncAfter(deadline: .now() + 0.4) {
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
        .safeAreaInset(edge: .top) {
            if status.index == nil {
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
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 5)
                        .allowsHitTesting(false)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .disabled(status.items.isEmpty)
                .padding(.top)
            }
        }
        .safeAreaInset(edge: .bottom) {
            if status.index == nil && !create {
                Button {
                    offset = UIScreen.main.bounds.height
                    create = true
                    
                    withAnimation(.easeInOut(duration: 0.45)) {
                        offset = 0
                    }

                    DispatchQueue
                        .main
                        .asyncAfter(deadline: .now() + 0.45) {
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
                .padding(.bottom)
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
            withAnimation(.easeInOut(duration: 0.4)) {
                status.index = nil
            }
        }
    }
}
