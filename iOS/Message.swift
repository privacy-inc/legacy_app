import SwiftUI

struct Message: View {
    let web: Web
    let info: Info
    
    var body: some View {
        VStack {
            Image(systemName: info.icon)
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 35, weight: .light))
                .padding(.top, 40)
            Text("\(location)\(Text(info.title).foregroundColor(.secondary))")
                .font(.callout)
                .foregroundColor(Color(.tertiaryLabel))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .padding()
                .padding(.horizontal)
            Spacer()
        }
        .foregroundStyle(.secondary)
        .frame(maxWidth: .greatestFiniteMagnitude)
        .background(Color(.secondarySystemBackground))
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Bar(items: [
                    .init(icon: "chevron.backward") {
                        if web.url == nil {
                            web.session.change(flow: .search(false), of: web.id)
                        } else {
                            web.session.change(flow: .web, of: web.id)
                        }
                    },
                    .init(icon: "arrow.clockwise") {
                        web.session.change(flow: .web, of: web.id)
                        info
                            .url
                            .map {
                                web.load(url: $0)
                            }
                        
                    },
                    .init(icon: "magnifyingglass") {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            web.session.change(flow: .search(true), of: web.id)
                        }
                    },
                    .init(icon: "square.on.square") {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            web.session.current = .tabs
                        }
                    }
                ],
                    material: .ultraThin)
            }
    }
    
    private var location: String {
        info.url == nil ? "" :  "\(info.url!.absoluteString.capped(max: 100))\n"
    }
}
