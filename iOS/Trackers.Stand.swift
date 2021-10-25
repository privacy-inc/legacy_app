import SwiftUI

extension Trackers {
    struct Stand: View {
        @Binding var display: Bool
        
        var body: some View {
            NavigationView {
                Trackers()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                display = false
                            } label: {
                                Text("Done")
                                    .font(.callout)
                                    .foregroundColor(.init("Shades"))
                                    .padding(.leading)
                                    .frame(height: 34)
                                    .allowsHitTesting(false)
                                    .contentShape(Rectangle())
                            }
                        }
                    }
            }
            .navigationViewStyle(.stack)
        }
    }
}
