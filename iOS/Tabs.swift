import SwiftUI
import Combine

struct Tabs: View {
    @Binding var items: [Status.Item]
    @State var transition: Transition?
    let tab: (Int, Bool) -> Void
    @State private var entering = true
    @Namespace private var animating
    private let scroll = PassthroughSubject<UUID, Never>()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: .init(colors: [.init(.systemFill), .init(.secondarySystemFill)]),
                                       startPoint: .bottom, endPoint: .top)
                .edgesIgnoringSafeArea(.all)
                .allowsHitTesting(false)
            scrollView
            closeAll
            add
            if transition != nil {
                Snap(image: items[transition!.index].image, size: transition!.size)
                    .edgesIgnoringSafeArea(.all)
                    .allowsHitTesting(false)
                    .matchedGeometryEffect(id: items[transition!.index].id, in: animating, properties: .position, isSource: !entering)
            }
        }
        .task {
            scroll.send(items[transition!.index].id)
            
            withAnimation(.easeInOut(duration: 0.3)) {
                transition!.size = 150
            }
            
            DispatchQueue
                .main
                .asyncAfter(deadline: .now() + 0.3) {
                    transition = nil
                }
        }
    }
    
    private func open(id: UUID, search: Bool) {
        let index = items
            .firstIndex {
                $0.id == id
            }!
        
        entering = false
        
        withAnimation(.easeInOut(duration: 0.1)) {
            transition = .init(size: 150, index: index)
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            transition?.size = nil
        }
        
        DispatchQueue
            .main
            .asyncAfter(deadline: .now() + 0.2) {
                tab(index, search)
            }
    }
    
    private var scrollView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    Spacer()
                        .frame(width: 20)
                        .frame(maxHeight: .greatestFiniteMagnitude)
                    ForEach(items) {
                        if transition != nil && $0.id == items[transition!.index].id {
                            item($0)
                        } else {
                            item($0)
                        }
                    }
                    Spacer()
                        .frame(width: 20)
                        .frame(maxHeight: .greatestFiniteMagnitude)
                }
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
            .onReceive(scroll) {
                proxy.scrollTo($0, anchor: .center)
            }
        }
    }
    
    private var add: some View {
        Group {
            Button {
                items.append(.init())
                
                DispatchQueue
                    .main
                    .asyncAfter(deadline: .now() + 0.1) {
                        
                        withAnimation(.easeInOut(duration: 0.2)) {
                            scroll.send(items.last!.id)
                        }
                        
                        open(id: items.last!.id, search: true)
                    }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.init("Shades"))
                    .allowsHitTesting(false)
            }
            .padding(.bottom)
        }
        .frame(maxHeight: .greatestFiniteMagnitude, alignment: .bottom)
    }
    
    private var closeAll: some View {
        Group {
            Button {
                items
                    .forEach {
                        $0
                            .web?
                            .clear()
                    }
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    items = []
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
            .padding(.top)
            .disabled(items.isEmpty)
        }
        .frame(maxHeight: .greatestFiniteMagnitude, alignment: .top)
    }
    
    private func item(_ item: Status.Item) -> some View {
        Item(item: item, animating: animating, entering: entering) {
            open(id: item.id, search: false)
        } close: {
            withAnimation(.easeInOut(duration: 0.3)) {
                items
                    .remove {
                        $0.id == item.id
                    }?
                    .web?
                    .clear()
            }
        }
    }
}
