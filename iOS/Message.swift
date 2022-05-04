import SwiftUI

struct Message: View {
    let session: Session
    let index: Int
    
    var body: some View {
        VStack {
            Image(systemName: session.items[index].info?.icon ?? "")
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 35, weight: .light))
                .padding(.top, 40)
            Text("\(location)\(Text(session.items[index].info?.title ?? "").foregroundColor(.secondary))")
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
                    .init(size: 17, icon: "chevron.backward") {
                        if session.items[index].web!.url == nil {
                            session.items[index].flow = .search(false)
                        } else {
                            session.items[index].flow = .web
                        }
                        session.objectWillChange.send()
                    },
                    .init(size: 16, icon: "arrow.clockwise") {
                        let url = session
                            .items[index]
                            .info?
                            .url
                        
                        session.items[index].flow = .web
                        session.objectWillChange.send()
                        url
                            .map(session.items[index].web!.load(url:))
                    },
                    .init(size: 20, icon: "magnifyingglass") {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            session.items[index].flow = .search(true)
                            session.objectWillChange.send()
                        }
                    },
                    .init(size: 16, icon: "square.on.square") {
                        session.previous = index
                        withAnimation(.easeInOut(duration: 0.4)) {
                            session.current = nil
                        }
                    }
                ],
                    material: .ultraThin)
            }
    }
    
    private var location: String {
        session.items[index].info?.url == nil ? "" :  "\(session.items[index].info!.url!.absoluteString.capped(max: 100))\n"
    }
}
