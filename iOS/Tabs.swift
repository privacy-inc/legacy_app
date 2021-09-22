import SwiftUI

struct Tabs: View {
    @Binding var status: [Navigation.Status]
    @State var minimize: Minimize
    @State private var snap = true
    @Namespace private var minimising
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: .init(colors: [.init(.systemFill), .init(.secondarySystemFill)]),
                                       startPoint: .bottom, endPoint: .top)
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 20) {
                        Spacer()
                            .frame(width: 20)
                            .frame(maxHeight: .greatestFiniteMagnitude)
                        ForEach(status) {
                            if $0.id == status[minimize.index].id {
                                if !snap {
                                    Item(status: $0)
                                        .id($0.id)
                                        .matchedGeometryEffect(id: $0.id, in: minimising, properties: .position, isSource: false)
                                }
                            } else {
                                Item(status: $0)
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
                    proxy.scrollTo(status[minimize.index].id, anchor: .center)
                }
            }
            Group {
                Button {
                    
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.init("Shades"))
                }
            }
            .frame(maxHeight: .greatestFiniteMagnitude, alignment: .bottom)
            .padding(.bottom, 50)
            if snap {
                Snap(image: status[minimize.index].image, size: minimize.size)
                    .allowsHitTesting(false)
                    .matchedGeometryEffect(id: status[minimize.index].id, in: minimising, properties: .position, isSource: true)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .task {
            withAnimation(.easeInOut(duration: 0.3)) {
                minimize.size = 150
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    snap = false
                }
            }
        }
    }
}
