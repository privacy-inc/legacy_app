import SwiftUI

struct Navigation: View {
    @ObservedObject var session: Session
    
    var body: some View {
        if let index = session.current {
            switch session.items[index].flow {
            case .web:
                Browser(session: session, index: index)
                    .id(index)
            case .message:
                Message(session: session, index: index)
            case let .search(focus):
                Search(field: .init(session: session, index: index), focus: focus)
            }
        } else {
            Tabs(session: session)
        }
    }
}
