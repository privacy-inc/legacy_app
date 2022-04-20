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
                    session.current = session.items.firstIndex(of: item)!
                } label: {
                    switch item.flow {
                    case .message:
                        VStack(spacing: 10) {
                            Image(systemName: item.info!.icon)
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 30, weight: .light))
                                .frame(maxWidth: .greatestFiniteMagnitude)
                                .padding(.vertical, 40)
                                .modifier(Card(dark: session.dark))
                                .foregroundStyle(.secondary)
                            Text("\(item.info!.title) \(Text(item.info!.url?.absoluteString.domain ?? "").foregroundColor(.secondary))")
                                .font(.caption2)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                                .padding(.horizontal, 10)
                                .padding(.bottom)
                        }
                    default:
                        if let web = item.web {
                            VStack(spacing: 10) {
                                Image(uiImage: item.thumbnail)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxHeight: Self.height, alignment: .top)
                                    .modifier(Card(dark: session.dark))
                                Text("\(web.title?.capped(max: 90) ?? "") \(Text(web.url?.absoluteString.domain ?? "").foregroundColor(.secondary))")
                                    .font(.caption2)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                                    .padding(.horizontal, 10)
                                    .padding(.bottom)
                            }
                        } else {
                            VStack(spacing: 10) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 20, weight: .light))
                                    .frame(maxWidth: .greatestFiniteMagnitude)
                                    .padding(.vertical, 30)
                                    .modifier(Card(dark: session.dark))
                                Text("New tab")
                                    .font(.caption2)
                                    .padding(.bottom)
                            }
                            .foregroundStyle(.secondary)
                        }
                    }
                }
                
                if item.web == nil || item.flow == .message {
                    Button(action: close) {
                        Image(systemName: "xmark")
                            .foregroundColor(.secondary)
                            .font(.system(size: 15, weight: .light))
                            .padding(14)
                            .contentShape(Rectangle())
                    }
                } else {
                    Circle()
                        .fill(Color(.tertiarySystemBackground))
                        .frame(width: 32, height: 32)
                        .padding(.trailing, 10.5)
                        .padding(.top, 10)
                        .shadow(color: .black.opacity(session.dark ? 1 : 0.4), radius: 2)
                        .allowsHitTesting(false)
                    
                    Button(action: close) {
                        Image(systemName: "xmark")
                            .foregroundColor(.secondary)
                            .font(.system(size: 15, weight: .light))
                            .padding(19)
                            .contentShape(Rectangle())
                    }
                }
            }
        }
    }
}
