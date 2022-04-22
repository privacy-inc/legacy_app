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
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    Text(.init(text))
                        .font(.callout)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: 500)
                        .padding(30)
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
