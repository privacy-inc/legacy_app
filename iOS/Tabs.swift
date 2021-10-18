import SwiftUI
import Combine

struct Tabs: View {
    @Binding var status: Status
    let tab: () -> Void
    let add: () -> Void
    @State private var animate = true
    @State private var size: CGFloat?
    private let scroll = PassthroughSubject<UUID, Never>()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: .init(colors: [.init(.systemFill), .init(.secondarySystemFill)]),
                                       startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea(edges: .all)
                .allowsHitTesting(false)
            scrollView
            controls
            if animate {
                Snap(image: status.item.image, size: size)
                    .ignoresSafeArea(edges: .all)
            }
        }
        .task {
            scroll.send(status.item.id)
            withAnimation(.easeInOut(duration: 0.3)) {
                size = 150
            }
            
            DispatchQueue
                .main
                .asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        animate = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                        scroll.send(status.item.id)
                    }
                }
            
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
                        .frame(width: padding)
                        .frame(maxHeight: .greatestFiniteMagnitude)
                    ForEach(status.items) {
                        item($0)
                    }
                    Spacer()
                        .frame(width: padding)
                        .frame(maxHeight: .greatestFiniteMagnitude)
                }
            }
            .ignoresSafeArea(edges: .all)
            .onReceive(scroll) {
                proxy.scrollTo($0, anchor: .center)
            }
        }
    }
    
    private var controls: some View {
        VStack {
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
            
            Spacer()
            
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
    }
    
    private func item(_ item: Status.Item) -> some View {
        Item(item: item) {
            status.index = status
                .items
                .firstIndex {
                    $0.id == item.id
                }!
            
//            DispatchQueue
//                .main
//                .asyncAfter(deadline: .now() + 0.1) {
//                    withAnimation(.easeInOut(duration: 2)) {
//                        transition = .leave
//                    }
//                }
//
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
    
    private var padding: CGFloat {
        (UIScreen.main.bounds.width - 170) / 2
    }
}
