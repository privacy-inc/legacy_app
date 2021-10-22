import SwiftUI

extension Forget {
    struct Item: View {
        let title: String
        let icon: String
        let primary: Color
        let secondary: Color
        let action: () async -> Void
        @State private var activated = false
        
        var body: some View {
            if activated {
                Text("\(Text(title).foregroundColor(.secondary).font(.callout)) \(Image(systemName: "checkmark.circle.fill"))")
                    .foregroundStyle(.blue)
                    .imageScale(.large)
                    .font(.title3)
                    .listRowBackground(Color.clear)
                    .allowsHitTesting(false)
            } else {
                Button {
                    Task
                        .detached(priority: .utility) {
                            await action()
                        }
                    
                    activated = true
                    
                    DispatchQueue
                        .main
                        .asyncAfter(deadline: .now() + 6) {
                            activated = false
                        }
                } label: {
                    Label("\(Text(title).foregroundColor(.primary))", systemImage: icon)
                        .foregroundStyle(primary, secondary)
                        .font(.callout)
                }
            }
        }
    }
}
