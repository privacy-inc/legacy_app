import SwiftUI
import Specs

private let size = CGFloat(24)

extension Search {
    struct Item: View {
        let session: Session
        let website: Website
        @StateObject private var icon = Icon()
        
        var body: some View {
            Button {
                
            } label: {
                ZStack(alignment: .topLeading) {
                    if let image = icon.image {
                        text(string: "\(Image(uiImage: Self.blank)) \(website.title) \(domain)")
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                            .frame(width: size, height: size)
                            .allowsHitTesting(false)
                    } else {
                        text(string: "\(website.title) \(domain)")
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(.tertiarySystemBackground))
                            .shadow(color: .black.opacity(session.dark ? 1 : 0.1), radius: 4))
            .task {
                await icon.load(website: .init(string: website.id))
            }
        }
        
        private var domain: Text {
            Text(verbatim: website.id.domain)
                .foregroundColor(.secondary)
        }
        
        private func text(string: LocalizedStringKey) -> some View {
            Text(string)
                .font(.footnote)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
        }
        
        private static let blank: UIImage = {
            UIGraphicsBeginImageContext(.init(width: size, height: size))
            let image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return image
        } ()
    }
}
