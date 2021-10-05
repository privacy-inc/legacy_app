import SwiftUI

struct Search: View, Equatable {
    let tab: () -> Void
    let searching: (String) -> Void
    
    var body: some View {
        ScrollView {
            Section("Bookmarks") {
                VStack {
                    ForEach(0 ..< 2) {
                        if $0 > 0 {
                            separator
                        }
                        Text("\($0)")
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                            .padding()
                    }
                }
            }
            Section("History") {
                VStack {
                    ForEach(0 ..< 2) {
                        if $0 > 0 {
                            separator
                        }
                        Text("\($0)")
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                            .padding()
                    }
                }
            }
            Representable(searching: searching)
                .frame(height: 1)
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .background(.ultraThickMaterial)
        .safeAreaInset(edge: .top, spacing: 0) {
            Header(tab: tab)
        }
    }
    
    private var separator: some View {
        Rectangle()
            .fill(Color.primary.opacity(0.05))
            .frame(height: 1)
            .padding(.leading, 40)
            .padding(.trailing, 2)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}