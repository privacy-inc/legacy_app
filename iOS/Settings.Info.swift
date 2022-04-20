import SwiftUI

extension Settings {
    struct Info: View {
        let title: String
        let text: String
        
        var body: some View {
            ScrollView {
                ZStack {
                    Rectangle()
                        .fill(Color(.systemBackground))
                    Text(.init(text))
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        .padding()
                }
                .padding(.bottom)
                .padding(.bottom)
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
            .background(Color.primary.opacity(0.1))
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
