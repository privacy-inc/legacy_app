import SwiftUI
import Specs

struct Search: View {
    @StateObject var field: Field
    @State private var items = [[Website]]()
    
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
                                Item(session: field.session, website: $0)
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
                    field.typing ?
                .init(icon: "xmark", action: {
                    field.cancel()
                }) :
                    .init(icon: "magnifyingglass", action: {
                        field.becomeFirstResponder()
                    }),
                trailing:
                    .init(icon: "square.on.square", action: {
                        
                    }),
                material: .ultraThin)
        }
        .onChange(of: field.websites) {
            items = $0
                .reduce(into: .init(repeating: [Website](), count: 2)) {
                    if $0[0].count > $0[1].count {
                        $0[1].append($1)
                    } else {
                        $0[0].append($1)
                    }
                }
        }
        .onAppear {
            if field.focus {
                field.becomeFirstResponder()
            }
        }
    }
}
