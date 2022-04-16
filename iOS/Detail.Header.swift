import SwiftUI

extension Detail {
    struct Header: View {
        let url: URL?
        let title: String
        let secure: Bool
        @StateObject private var icon = Icon()
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            ZStack(alignment: .top) {
                VStack {
                    if let image = icon.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                            .frame(width: 50, height: 50)
                            .padding(.top, 30)
                    } else {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20, weight: .light))
                            .foregroundStyle(.tertiary)
                            .padding(.top, 30)
                    }
                    
                    Text("\(title) \(Text(url?.absoluteString.domain ?? "").foregroundColor(.secondary))")
                        .font(.callout)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                .allowsHitTesting(false)
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: secure ? "lock.fill" : "exclamationmark.triangle.fill")
                            .foregroundStyle(.secondary)
                            .symbolRenderingMode(.hierarchical)
                            .font(.system(size: secure ? 17 : 20, weight: .light))
                            .padding(18)
                            .contentShape(Rectangle())
                    }
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.secondary)
                            .font(.system(size: 15, weight: .light))
                            .padding(18)
                            .contentShape(Rectangle())
                    }
                }
            }
            .onChange(of: url) { url in
                Task {
                    await icon.load(website: url)
                }
            }
            .task {
                await icon.load(website: url)
            }
        }
    }
}
