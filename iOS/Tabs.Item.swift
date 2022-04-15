import SwiftUI
import Specs

extension Tabs {
    struct Item: View {
        let session: Session
        let item: Session.Item
        
        var body: some View {
            Button {
                
            } label: {
                switch item.flow {
                case let .message(url, title, icon):
                    Circle()
                default:
                    if let web = item.web {
                        VStack(spacing: 0) {
                            if let thumbnail = item.thumbnail {
                                Image(uiImage: thumbnail)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxHeight: 170, alignment: .top)
                                    .clipped()
                            }
                            Divider()
                            Text("\(web.title?.capped ?? "") \(Text(web.url?.absoluteString.domain ?? "").foregroundColor(.secondary))")
                                .font(.footnote)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                                .padding()
                        }
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 20, weight: .light))
                                .foregroundStyle(.secondary)
                            Text("New tab")
                                .frame(maxWidth: .greatestFiniteMagnitude)
                                .font(.footnote)
                                .foregroundStyle(.tertiary)
                        }
                        .padding(.vertical)
                    }
                }
                
                
//                ZStack(alignment: .topLeading) {
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
//                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .background(Color(.tertiarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: .black.opacity(session.dark ? 1 : 0.1), radius: 4)
        }
    }
}
