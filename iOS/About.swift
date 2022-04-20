import SwiftUI
import Specs

struct About: View {
    var body: some View {
        ScrollView {
            Layer()
                .equatable()
                .frame(height: 350)
            Text("Privacy \(Image(systemName: "plus"))")
                .font(.title2)
            Text("Support research and\ndevelopment of Privacy Browser")
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            Text("Privacy Browser")
                .font(.footnote)
                .padding(.top, 30)
            Text(verbatim: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")
                .font(.caption)
                .foregroundStyle(.tertiary)
            HStack(spacing: 0) {
                Text("From Berlin with ")
                    .foregroundStyle(.tertiary)
                    .font(.caption)
                Image(systemName: "heart.fill")
                    .font(.footnote)
                    .foregroundStyle(.pink)
            }
        }
    }
}
