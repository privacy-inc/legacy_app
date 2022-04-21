import SwiftUI

struct Browser: View {
    let session: Session
    let index: Int
    @StateObject private var status = Status()
    @State private var detail = false
    
    var body: some View {
        session
            .items[index]
            .web!
            .transition(.identity)
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
                            session.previous = index
                            withAnimation(.easeInOut(duration: 0.4)) {
                                session.current = nil
                            }
                        }
                    }
                ],
                    material: .regular)
                        .sheet(isPresented: $detail) {
                            Detail(status: status, session: session, index: index)
                                .ignoresSafeArea(edges: .bottom)
                        }
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                Features(status: status, session: session, index: index)
            }
            .task {
                status.reader = session.items[index].reader
                status.find = session.items[index].find
            }
    }
}
