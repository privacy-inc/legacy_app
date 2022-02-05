import SwiftUI

extension Landing {
    struct Clear: View {
        let clear: () -> Void
        @State private var forget = false
        
        var body: some View {
            Button {
                forget = true
            } label: {
                Label("Forget", systemImage: "flame")
                    .font(.callout)
                    .imageScale(.large)
            }
            .foregroundStyle(.secondary)
            .padding(.vertical, 20)
            .confirmationDialog("Forget", isPresented: $forget, titleVisibility: .visible) {
                Button("Cache", action: Forget.cache)
                Button("History") {
                    Forget.history()
                    clear()
                }
                Button("Activity", action: Forget.activity)
                Button("Everything", role: .destructive) {
                    Forget.everything()
                    clear()
                }
            }
        }
    }
}
