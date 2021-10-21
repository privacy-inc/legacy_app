import SwiftUI

struct Info: View {
    let title: String
    let text: String
    
    var body: some View {
        ScrollView {
            Text(.init(text))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .padding()
                .padding(.bottom)
                .allowsHitTesting(false)
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .background(.ultraThickMaterial)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
    }
}
