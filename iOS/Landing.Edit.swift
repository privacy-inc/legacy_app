import SwiftUI

extension Landing {
    struct Edit: View {
        @State private var editing = false
        
        var body: some View {
            Button {
                editing = true
            } label: {
                Label("Configure", systemImage: "slider.vertical.3")
                    .font(.callout)
                    .imageScale(.large)
            }
            .foregroundStyle(.secondary)
            .padding(.vertical, 50)
            .sheet(isPresented: $editing) {
                Representable(rootView: .init())
            }
        }
    }
}
