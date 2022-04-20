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
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
            .background(Color(.secondarySystemBackground))
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
