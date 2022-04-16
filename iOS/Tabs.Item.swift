import SwiftUI
import Specs

extension Tabs {
    struct Item: View {
        private static let height = UIScreen.main.bounds.width * 0.5
        
        let session: Session
        let item: Session.Item
        let close: () -> Void
        
        var body: some View {
            ZStack(alignment: .topTrailing) {
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
                
                Circle()
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 32, height: 32)
                    .padding(.trailing, 10.5)
                    .padding(.top, 10)
                    .shadow(color: .black.opacity(session.dark ? 1 : 0.4), radius: 3)
                    .allowsHitTesting(false)
                
                Circle()
                    .stroke(Color(.tertiarySystemBackground), lineWidth: 1)
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 11.5)
                    .padding(.top, 11)
                    .allowsHitTesting(false)
                
                Button(action: close) {
                    Image(systemName: "xmark")
                        .symbolRenderingMode(.palette)
                        .foregroundColor(.secondary)
                        .font(.system(size: 15, weight: .light))
                        .padding(19)
                        .contentShape(Rectangle())
                }
            }
        }
    }
}
