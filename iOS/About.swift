import SwiftUI

struct About: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            Layer()
                .equatable()
                .frame(height: 400)
            HStack(spacing: 0) {
                Text("Privacy ")
                    .font(.title2)
                Image(systemName: "plus")
                    .font(.title2.weight(.light))
            }
            Text("Support research and\ndevelopment of Privacy Browser")
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Plus()
            
            HStack(spacing: 0) {
                Text("Privacy Browser ")
                    .font(.footnote)
                Text(verbatim: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            HStack(spacing: 0) {
                Text("From Berlin with ")
                    .foregroundStyle(.tertiary)
                    .font(.caption)
                Image(systemName: "heart.fill")
                    .font(.footnote)
                    .foregroundStyle(.pink)
            }
            .padding(.bottom)
        }
    }
}
