import SwiftUI

struct Froob: View {
    @State private var about = false
    
    var body: some View {
        VStack {
            Text("Support Privacy Browser")
                .font(.body.weight(.medium))
            Text("Give your support to the independent team behind this browser.")
                .multilineTextAlignment(.center)
                .font(.callout.weight(.regular))
                .fixedSize(horizontal: false, vertical: true)
                .foregroundStyle(.secondary)
                .frame(maxWidth: 280)
            Button {
                about = true
            } label: {
                Text("Privacy Plus")
                    .font(.callout.weight(.medium))
                    .frame(minWidth: 260)
                    .frame(minHeight: 28)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .foregroundColor(.white)
        }
        .padding(30)
        .padding(.bottom, 10)
        .sheet(isPresented: $about, content: About.init)
    }
}
