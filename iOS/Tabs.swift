import SwiftUI

struct Tabs: View {
    @Binding var status: [Navigation.Status]
    @State var transition: Transition?
    let tab: (Int) -> Void
    @Namespace private var animating
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: .init(colors: [.init(.systemFill), .init(.secondarySystemFill)]),
                                       startPoint: .bottom, endPoint: .top)
                .edgesIgnoringSafeArea(.all)
            scrollView
            add
            if transition != nil {
                Snap(image: status[transition!.index].image, size: transition!.size)
                    .edgesIgnoringSafeArea(.all)
                    .allowsHitTesting(false)
                    .matchedGeometryEffect(id: status[transition!.index].id, in: animating, properties: .position, isSource: true)
            }
        }
        .task {
            withAnimation(.easeInOut(duration: 0.3)) {
                transition!.size = 150
            }
            
            DispatchQueue
                .main
                .asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        transition = nil
                    }
                }
        }
    }
    
    private func open(_ id: UUID) {
        let index = status
            .firstIndex {
                $0.id == id
            }!
        withAnimation(.easeInOut(duration: 0.2)) {
            transition = .init(size: 150, index: index)
        }
        
        DispatchQueue
            .main
            .asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.35)) {
                    transition?.size = nil
                }
            }
        
        DispatchQueue
            .main
            .asyncAfter(deadline: .now() + 0.55) {
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
                            Item(status: $0)
                                .matchedGeometryEffect(id: $0.id, in: animating, properties: .position, isSource: false)
                                .id($0.id)
                        } else {
                            Item(status: $0)
                                .matchedGeometryEffect(id: $0.id, in: animating, properties: .position, isSource: false)
                                .id($0.id)
                        }
                    }
                    Spacer()
                        .frame(width: 20)
                        .frame(maxHeight: .greatestFiniteMagnitude)
                }
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
            .onAppear {
                proxy.scrollTo(status[transition!.index].id, anchor: .center)
            }
        }
    }
    
    private var add: some View {
        Group {
            Button {
                status.append(.init())
                open(status.last!.id)
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
}
