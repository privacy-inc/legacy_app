import SwiftUI
import Specs

extension Tabs {
    struct Item: View {
        private static let height = UIScreen.main.bounds.width * 0.5
        
        let session: Session
        let item: Session.Item
        
        var body: some View {
            Button {
                session.current = .item(item.id)
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
                                    .frame(maxHeight: Self.height, alignment: .top)
                                    .modifier(Card(dark: session.dark))
                            }
                            Text("\(web.title?.capped(max: 90) ?? "") \(Text(web.url?.absoluteString.domain ?? "").foregroundColor(.secondary))")
                                .font(.caption2)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                                .padding([.leading, .trailing, .top], 10)
                                .padding(.bottom)
                        }
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 20, weight: .light))
                                .frame(maxWidth: .greatestFiniteMagnitude)
                                .padding(.vertical, 30)
                                .modifier(Card(dark: session.dark))
                            Text("New tab")
                                .font(.caption2)
                                .padding(.top, 6)
                                .padding(.bottom)
                        }
                        .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}
