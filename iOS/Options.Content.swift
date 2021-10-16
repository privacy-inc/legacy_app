import SwiftUI
import Combine
import Specs

extension Options {
    struct Content: View {
        let web: Web
        let share: PassthroughSubject<Void, Never>
        let find: () -> Void
        @State private var loading = false
        @State private var title = ""
        @State private var url: URL?
        @State private var access: AccessType?
        @State private var publisher: Favicon.Pub?
        @State private var backwards = false
        @State private var forwards = false
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            ScrollView(showsIndicators: false) {
                icon
                navigation
                
                if let url = url {
                    address(url: url)
                }
                
                controls
            }
            .background(.thickMaterial)
            .onReceive(web.publisher(for: \.isLoading)) { value in
                loading = value
            }
            .onReceive(web.publisher(for: \.url)) { value in
                url = value
                update()
            }
            .onReceive(web.publisher(for: \.title)) { value in
                title = value ?? ""
            }
            .onReceive(web.publisher(for: \.canGoBack)) { value in
                backwards = value
            }
            .onReceive(web.publisher(for: \.canGoForward)) { value in
                forwards = value
            }
        }
        
        private func update() {
            publisher = nil
            access = nil
            
            Task {
                access = await cloud.website(history: web.history)?.access
                if let access = access, let publisher = await favicon.publisher(for: access) {
                    update(publisher: publisher)
                }
            }
        }
        
        private func update(publisher: Favicon.Pub) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.publisher = publisher
            }
        }
        
        private var icon: some View {
            HStack(alignment: .top) {
                Spacer()
                    .frame(width: 70)
                
                Spacer()
                
                if let publisher = publisher, let access = access {
                    Icon(size: 48, access: access, publisher: publisher)
                        .allowsHitTesting(false)
                } else {
                    Image(systemName: "globe")
                        .font(.title)
                        .foregroundStyle(.quaternary)
                        .frame(width: 48, height: 48)
                        .allowsHitTesting(false)
                }
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.secondary)
                        .allowsHitTesting(false)
                }
                .frame(width: 70)
            }
            .frame(height: 90)
        }
        
        private var navigation: some View {
            HStack(spacing: 20) {
                Action(symbol: "chevron.backward", active: backwards) {
                    web.goBack()
                    update()
                }
                
                Action(symbol: loading ? "xmark" : "arrow.clockwise", active: true) {
                    if loading {
                        web.stopLoading()
                    } else {
                        web.reload()
                        dismiss()
                    }
                }
                
                Action(symbol: "chevron.forward", active: forwards) {
                    web.goForward()
                    update()
                }
            }
        }
        
        @ViewBuilder private func address(url: URL) -> some View {
            Text(verbatim: title)
                .foregroundStyle(.primary)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
                .padding([.leading, .trailing, .top], 35)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .allowsHitTesting(false)
            
            Group {
                switch url.scheme?.lowercased() {
                case "https":
                    Label(url.absoluteString, systemImage: "lock.fill")
                case "http":
                    Label(url.absoluteString, systemImage: "exclamationmark.triangle.fill")
                default:
                    Text(verbatim: url.absoluteString)
                }
            }
            .font(.callout)
            .foregroundStyle(.secondary)
            .symbolRenderingMode(.hierarchical)
            .lineLimit(2)
            .padding([.leading, .trailing, .bottom], 35)
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            .allowsHitTesting(false)
        }
        
        @ViewBuilder private var controls: some View {
            Control(title: "Share", symbol: "square.and.arrow.up") {
                share.send()
            }
            
            Control(title: "Bookmark", symbol: "bookmark") {
                dismiss()
                Task
                    .detached {
                        await UNUserNotificationCenter.send(message: "Bookmark added!")
                        await cloud.bookmark(history: web.history)
                    }
            }
            
            Control(title: "Find on page", symbol: "rectangle.and.text.magnifyingglass") {
                dismiss()
                find()
            }
        }
    }
}
