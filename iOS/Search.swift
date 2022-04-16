import SwiftUI
import Specs

struct Search: View {
    @StateObject var field: Field
    let focus: Bool
    @State private var items = [[Website]]()
    
    var body: some View {
        ScrollView {
            field
                .equatable()
                .frame(height: 1)
            if items.first?.isEmpty == true {
                Text("No bookmarks or history\nto show")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top)
                    .padding(.leading, 30)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            } else {
                HStack(alignment: .top, spacing: 9) {
                    ForEach(0 ..< items.count, id: \.self) { index in
                        LazyVStack {
                            ForEach(items[index]) {
                                Item(field: field, website: $0)
                            }
                        }
                    }
                }
                .padding(.horizontal, 9)
                .padding(.vertical)
            }
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .background(.ultraThickMaterial)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Bar(items: [
                .init(icon: "line.3.horizontal") {
                    
                },
                field.typing ? .init(icon: "xmark") {
                    field.cancel(clear: true)
                } : .init(icon: "magnifyingglass") {
                    field.becomeFirstResponder()
                },
                .init(icon: "square.on.square") {
                    field.cancel(clear: false)
                    
                    Task {
                        await field.session.item(for: field.id).web?.thumbnail()
                        
                        withAnimation(.easeInOut(duration: 0.4)) {
                            field.session.current = .tabs
                        }
                    }
                }
            ],
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
            if focus {
                field.becomeFirstResponder()
            }
        }
    }
}
