import SwiftUI

struct Tabs: View {
    var body: some View {
        ScrollView(.horizontal) {
            Text("hello world")
        }
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background(Color(.secondarySystemBackground))
    }
}
