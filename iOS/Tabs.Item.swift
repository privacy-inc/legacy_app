import SwiftUI
import Specs

extension Tabs {
    struct Item: View {
        let session: Session
        let item: Session.Item
        
        var body: some View {
            Button {
                
            } label: {
                ZStack(alignment: .topLeading) {
//                    if let image = icon.image {
//                        text(string: "\(Image(uiImage: Self.blank)) \(website.title) \(domain)")
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFit()
//                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
//                            .frame(width: size, height: size)
//                            .allowsHitTesting(false)
//                    } else {
//                        text(string: "\(website.title) \(domain)")
//                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(.tertiarySystemBackground))
                            .shadow(color: .black.opacity(session.dark ? 1 : 0.1), radius: 4))
        }
    }
}
