import SwiftUI
import Combine

struct Tabs: View {
    @Binding var status: [Status]
    @State var transition: Transition?
    let tab: (Int) -> Void
    @State private var entering = false
    @Namespace private var animating
    private let scroll = PassthroughSubject<UUID, Never>()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: .init(colors: [.init(.systemFill), .init(.secondarySystemFill)]),
                                       startPoint: .bottom, endPoint: .top)
                .edgesIgnoringSafeArea(.all)
            scrollView
            add
            if transition != nil {
                VStack {
                    Snap(image: status[transition!.index].image, size: transition!.size)
                        .edgesIgnoringSafeArea(.all)
                        .allowsHitTesting(false)
                        .matchedGeometryEffect(id: status[transition!.index].id, in: animating, properties: .position, isSource: entering)
                }
            }
        }
        .task {
            scroll.send(status[transition!.index].id)
            
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
    
    private func open(_ id: UUID) {
        let index = status
            .firstIndex {
                $0.id == id
            }!
        
        entering = true
        
        withAnimation(.easeInOut(duration: 0.1)) {
            transition = .init(size: 150, index: index)
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            transition?.size = nil
        }
        
        DispatchQueue
            .main
            .asyncAfter(deadline: .now() + 0.3) {
                tab(index)
            }
    }
    
    private var scrollView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    Spacer()
                        .frame(width: 20)
                        .frame(maxHeight: .greatestFiniteMagnitude)
                    ForEach(status) {
                        if transition != nil && $0.id == status[transition!.index].id {
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
                status.append(.init())
                
                DispatchQueue
                    .main
                    .asyncAfter(deadline: .now() + 0.1) {
                        
                        withAnimation(.easeInOut(duration: 0.2)) {
                            scroll.send(status.last!.id)
                        }
                        
                        open(status.last!.id)
                    }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.init("Shades"))
            }
        }
        .frame(maxHeight: .greatestFiniteMagnitude, alignment: .bottom)
        .padding(.bottom)
    }
    
    private func item(_ status: Status) -> some View {
        VStack(spacing: 0) {
            Button {
                print("button \(#file)")
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2.weight(.light))
                    .foregroundStyle(.tertiary)
                    .symbolRenderingMode(.hierarchical)
            }
            .padding(.bottom, 20)
            
            Button {
                open(status.id)
            } label: {
                VStack(spacing: 0) {
                    Snap(image: status.image, size: 150)
                        .matchedGeometryEffect(id: status.id, in: animating, properties: .position, isSource: !entering)
                        .id(status.id)
                    Text(verbatim: status.title)
                        .font(.caption)
                        .lineLimit(1)
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                    Image(systemName: "bolt.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.init("Shades"))
                        .font(.title)
                }
            }
        }
    }
}
