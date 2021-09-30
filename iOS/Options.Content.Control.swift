import SwiftUI

extension Options.Content {
    struct Control: View {
        let title: String
        let icon: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.ultraThickMaterial)
                    HStack {
                        Text(title)
                            .font(.footnote)
                        Spacer()
                        Image(systemName: icon)
                            .font(.callout)
                            .frame(width: 24)
                    }
                    .padding(.horizontal)
                }
                .frame(width: 180, height: 36)
            }
        }
    }
}
