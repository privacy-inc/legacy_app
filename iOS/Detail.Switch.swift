import SwiftUI

extension Detail {
    struct Switch: View {
        let icon: String
        let title: String
        @Binding var value: Bool
        
        var body: some View {
            Toggle(isOn: $value) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .regular))
                        .symbolRenderingMode(.hierarchical)
                        .frame(width: 24)
                        .foregroundStyle(.secondary)
                    Text(title)
                        .font(.callout)
                }
            }
            .font(.callout)
            .padding(.vertical, 12)
        }
    }
}
