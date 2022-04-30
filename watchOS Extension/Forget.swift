import SwiftUI

struct Forget: View {
    @State private var forgotten = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Forget Everything")
                    .font(.body.weight(.medium))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                    .padding(.top)
                
                if forgotten {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundStyle(.white, .blue)
                        .padding(.bottom)
                        .padding(.bottom)
                } else {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 30, weight: .ultraLight))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.init("Dawn"))
                    
                    Button("Forget") {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            forgotten = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                forgotten = false
                            }
                        }
                        
                        Task
                            .detached(priority: .utility) {
                                await cloud.forget()
                            }
                    }
                    .font(.callout.weight(.semibold))
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .foregroundColor(.white)
                    .padding([.leading, .trailing, .bottom])
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
        }
    }
}
