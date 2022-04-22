import SwiftUI

extension Detail {
    struct Switch: View {
        @Binding var value: Bool
        let icon: String
        let title: String
        let divider: Bool
        @State private var alpha = 0.0
        
        var body: some View {
            Toggle(isOn: $value) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .regular))
                        .symbolRenderingMode(.hierarchical)
                        .frame(width: 24)
                    Text(title)
                        .font(.callout)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 30)
            .toggleStyle(SwitchToggleStyle(tint: .secondary))
            
            if divider {
                Divider()
                    .padding(.horizontal, 30)
            }
        }
    }
}
