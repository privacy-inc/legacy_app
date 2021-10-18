import SwiftUI
import Combine

struct Tabs: View {
    @Binding var status: Status
    private let scroll = PassthroughSubject<Void, Never>()
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    Spacer()
                        .frame(width: 30)
                        .frame(maxHeight: .greatestFiniteMagnitude)
                    ForEach(status.items) { item in
                        Item(item: item, selected: item.id == status.item?.id) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                status.index = status
                                    .items
                                    .firstIndex {
                                        $0.id == item.id
                                    }!
                            }
                            
                            DispatchQueue
                                .main
                                .asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        scroll.send()
                                    }
                                }
                            
                            DispatchQueue
                                .main
                                .asyncAfter(deadline: .now() + 0.35) {
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
                    Spacer()
                        .frame(width: 30)
                        .frame(maxHeight: .greatestFiniteMagnitude)
                }
            }
            .ignoresSafeArea(edges: .all)
            .onReceive(scroll) {
                status
                    .item
                    .map {
                        proxy.scrollTo($0.id, anchor: .center)
                    }
            }
        }
        .background(LinearGradient(gradient: .init(colors: [.clear, .primary.opacity(0.2)]), startPoint: .bottom, endPoint: .top))
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
            if status.index == nil {
                Button {
                    status.add()
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
        }
        .task {
            scroll.send()
            withAnimation(.easeInOut(duration: 0.35)) {
                status.index = nil
            }
        }
    }
}
