import SwiftUI
import Specs

extension Tabs {
    struct Item: View {
        private static let height = UIScreen.main.bounds.width * 0.5
        
        @Binding var selected: Session.Item?
        let session: Session
        let item: Session.Item
        let animation: Namespace.ID
        let close: () -> Void
        
        var body: some View {
            ZStack(alignment: .topTrailing) {
                Button {
                    if item.flow == .web && item.web != nil {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            selected = item
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            session.current = session.items.firstIndex(of: item)!
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            session.current = session.items.firstIndex(of: item)!
                        }
                    }
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
                                if selected == item {
                                    Spacer()
                                        .frame(height: Self.height)
                                } else {
                                    Image(uiImage: item.thumbnail)
                                        .resizable()
                                        .matchedGeometryEffect(id: "image.\(item.id)", in: animation)
                                        .scaledToFill()
                                        .frame(height: Self.height, alignment: .top)
                                        .modifier(Card(dark: session.dark))
                                }
                                Text("\(web.title?.capped(max: 160) ?? "") \(Text(web.url?.absoluteString.domain ?? "").foregroundColor(.secondary))")
                                    .font(.caption2)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                                    .padding(.horizontal, 10)
                                    .padding(.bottom, 8)
                            }
                        } else {
                            HStack(spacing: 10) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 20, weight: .light))
                                    .padding([.leading, .top, .bottom], 20)
                                Text("New tab")
                                    .font(.footnote)
                                Spacer()
                            }
                            .frame(maxWidth: .greatestFiniteMagnitude)
                            .foregroundStyle(.secondary)
                            .modifier(Card(dark: session.dark))
                        }
                    }
                }
                
                if item.web == nil || item.flow == .message {
                    Button(action: close) {
                        Image(systemName: "xmark")
                            .foregroundColor(.secondary)
                            .font(.system(size: 13, weight: .regular))
                            .padding(14)
                            .contentShape(Rectangle())
                    }
                } else {
                    Circle()
                        .fill(Color(.tertiarySystemBackground))
                        .frame(width: 28, height: 28)
                        .padding(.trailing, 11.5)
                        .padding(.top, 11)
                        .allowsHitTesting(false)
                    
                    Circle()
                        .fill(Color.primary)
                        .frame(width: 26, height: 26)
                        .padding(.trailing, 12.5)
                        .padding(.top, 12)
                        .allowsHitTesting(false)

                    Button(action: close) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(.tertiarySystemBackground))
                            .font(.system(size: 10, weight: .medium))
                            .padding(20)
                            .contentShape(Rectangle())
                    }
                }
            }
        }
    }
}
