import SwiftUI
import Specs

struct Search: View {
    @ObservedObject var session: Session
    let id: UUID
    private let field: Field
    @State private var items = [[Website]]()
    @State private var typing = false
    
    init(session: Session, id: UUID) {
        self.session = session
        self.id = id
        field = .init(session: session)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                field
                    .equatable()
                    .frame(height: 1)
                HStack(alignment: .top) {
                    ForEach(0 ..< items.count, id: \.self) { index in
                        LazyVStack {
                            ForEach(items[index]) {
                                Item(session: session, website: $0)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .background(.ultraThickMaterial)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Bar(leading:
                    .init(icon: "line.3.horizontal", action: {
                        
                    }),
                center:
                    typing ?
                .init(icon: "xmark", action: {
                    typing = false
                    field.cancel()
                }) :
                    .init(icon: "magnifyingglass", action: {
                        typing = true
                        field.becomeFirstResponder()
                    }),
                trailing:
                    .init(icon: "square.on.square", action: {
                        
                    }))
        }
        .onReceive(field.websites) {
            items = $0
                .reduce(into: .init(repeating: [Website](), count: 2)) {
                    if $0[0].count > $0[1].count {
                        $0[1].append($1)
                    } else {
                        $0[0].append($1)
                    }
                }
        }
    }
}
