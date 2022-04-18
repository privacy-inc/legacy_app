import SwiftUI

struct Browser: View {
    let session: Session
    let index: Int
    @StateObject private var status = Status()
    @State private var progress = AnimatablePair(Double(), Double())
    @State private var detail = false
    
    var body: some View {
        session
            .items[index]
            .web!
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Bar(items: [
                    .init(icon: "slider.vertical.3") {
                        status.small = true
                        detail = true
                    },
                    .init(icon: "magnifyingglass") {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            session.items[index].flow = .search(true)
                            session.objectWillChange.send()
                        }
                    },
                    .init(icon: "square.on.square") {
                        Task {
                            await session.items[index].web!.thumbnail()
                            
                            withAnimation(.easeInOut(duration: 0.4)) {
                                session.current = .tabs
                            }
                        }
                    }
                ],
                    material: .thin)
                        .sheet(isPresented: $detail) {
                            Detail(status: status, session: session, index: index)
                                .ignoresSafeArea(edges: .bottom)
                        }
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                VStack(spacing: 0) {
                    if status.reader {
                        Text("hello world")
                    }
                    
                    Progress(progress: progress)
                        .stroke(Color("Shades"), style: .init(lineWidth: 3, lineCap: .round))
                        .frame(height: 2)
                    Divider()
                }
                .background(.thinMaterial)
                .allowsHitTesting(false)
                .onReceive(session.items[index].web!.progress, perform: progress(value:))
            }
            .task {
                status.reader = session.items[index].reader
                status.find = session.items[index].find
            }
    }
    
    private func progress(value: Double) {
        guard value != 1 || progress.second != 0 else { return }
        
        progress.first = 0
        withAnimation(.easeInOut(duration: 0.5)) {
            progress.second = value
        }
        
        if value == 1 {
            DispatchQueue
                .main
                .asyncAfter(deadline: .now() + 0.7) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        progress = .init(1, 1)
                    }
                }
        }
    }
}
