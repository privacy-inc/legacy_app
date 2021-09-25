import SwiftUI

struct Tab: View {
    let history: Int
    let tabs: () -> Void
    let search: () -> Void
    
    var body: some View {
        Web(history: history)
            .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
            .safeAreaInset(edge: .bottom) {
                Bar(search: search) {
                    Button {
                        
                    } label: {
                        Image(systemName: "gear")
                            .symbolRenderingMode(.hierarchical)
                            .padding(.horizontal)
                    }
                    Spacer()
                } trailing: {
                    Spacer()
                    Button(action: tabs) {
                        Image(systemName: "square.on.square.dashed")
                            .symbolRenderingMode(.hierarchical)
                            .padding(.horizontal)
                    }
                }
            }
    }
}
