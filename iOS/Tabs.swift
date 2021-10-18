import SwiftUI
import Combine

struct Tabs: View {
    @Binding var status: Status
    let tab: () -> Void
    let add: () -> Void
    @State private var size: CGFloat?
    @State private var transition = Transition.enter
    @Namespace private var animating
    private let scroll = PassthroughSubject<UUID, Never>()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: .init(colors: [.init(.systemFill), .init(.secondarySystemFill)]),
                                       startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea(edges: .all)
                .allowsHitTesting(false)
            scrollView
            closeAll
            adding
            if transition != .none {
                Snap(image: status.item.image, size: size)
                    .allowsHitTesting(false)
                    .matchedGeometryEffect(id: status.item.id, in: animating)
                    .animation(.easeInOut(duration: 2))
                    
            }
        }
        
        .task {
            scroll.send(status.item.id)
            transition = .none
//            withAnimation(.easeInOut(duration: 2)) {
//
//                size = 150
//
//
//            }
//            withAnimation(.easeInOut(duration: 0.3)) {
//                transition!.size = 150
//            }
            
//            withAnimation(.easeInOut(duration: 2)) {
//                transition = nil
//            }
            
//            DispatchQueue
//                .main
//                .asyncAfter(deadline: .now() + 0.3) {
//                    transition = nil
//                }
        }
    }
    
    private var scrollView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    Spacer()
                        .frame(width: 20)
                        .frame(maxHeight: .greatestFiniteMagnitude)
                    ForEach(status.items) {
                        if transition == .none || (transition != .none && $0.id != status.item.id) {
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
    
    private var adding: some View {
        Group {
            Button {
                add()
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
        .frame(maxHeight: .greatestFiniteMagnitude, alignment: .bottom)
    }
    
    private var closeAll: some View {
        Group {
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
            .padding(.top)
            .disabled(status.items.isEmpty)
        }
        .frame(maxHeight: .greatestFiniteMagnitude, alignment: .top)
    }
    
    private func item(_ item: Status.Item) -> some View {
        Item(item: item, animating: animating, transition: transition) {
            status.index = status
                .items
                .firstIndex {
                    $0.id == item.id
                }!
            
            DispatchQueue
                .main
                .asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeInOut(duration: 2)) {
                        transition = .leave
                    }
                }
            
//            withAnimation(.easeInOut(duration: 0.2)) {
//                transition = .init(size: 150, index: status.index)
//            }
//
//            withAnimation(.easeInOut(duration: 0.5)) {
//                transition?.size = nil
//            }
            
//            DispatchQueue
//                .main
//                .asyncAfter(deadline: .now() + 0.4) {
//                    tab()
//                }
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
}
