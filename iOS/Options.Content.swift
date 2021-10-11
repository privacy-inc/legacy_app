import SwiftUI
import Combine
import Specs

extension Options {
    struct Content: View {
        let web: Web
        let share: PassthroughSubject<Void, Never>
        @State private var loading = false
        @State private var title = ""
        @State private var url: URL?
        @State private var access: AccessType?
        @State private var publisher: Favicon.Pub?
        @State private var backwards = false
        @State private var forwards = false
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            VStack(alignment: .leading) {
                navigation
                
                if !title.isEmpty {
                    heading
                }
                
                if let url = url {
                    address(url: url)
                }
                
                Spacer()
                
                controls
            }
            .padding()
            .background(.regularMaterial)
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
                access = await cloud.website(history: web.history).access
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
        
        private var navigation: some View {
            ZStack {
                HStack {
                    if let publisher = publisher, let access = access {
                        Icon(size: 48, access: access, publisher: publisher)
                    }
                    Spacer()
                }
                .frame(height: 58)
                .allowsHitTesting(false)
                
                HStack(alignment: .top) {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.quaternary)
                            .allowsHitTesting(false)
                    }
                }
                .frame(height: 58, alignment: .top)
                
                HStack {
                    Action(symbol: loading ? "xmark" : "arrow.clockwise", active: true) {
                        if loading {
                            web.stopLoading()
                        } else {
                            web.reload()
                            dismiss()
                        }
                    }
                    .padding(.leading, 74)
                    
                    Action(symbol: "chevron.backward", active: backwards) {
                        web.goBack()
                        update()
                    }
                    
                    Action(symbol: "chevron.forward", active: forwards) {
                        web.goForward()
                        update()
                    }
                    
                    Spacer()
                }
            }
        }
        
        private var heading: some View {
            Text(verbatim: title)
                .foregroundStyle(.secondary)
                .font(.callout)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .allowsHitTesting(false)
        }
        
        @ViewBuilder private func address(url: URL) -> some View {
            switch url.scheme?.lowercased() {
            case "https":
                connection(secure: true)
            case "http":
                connection(secure: false)
            default:
                EmptyView()
            }
            
            Text(verbatim: url.absoluteString)
                .foregroundStyle(.tertiary)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .font(.footnote)
                .lineLimit(2)
                .allowsHitTesting(false)
        }
        
        private func connection(secure: Bool) -> some View {
            Label(secure ? "Connection secure" : "Connection not secure", systemImage: secure ? "lock.fill" : "exclamationmark.triangle.fill")
                .foregroundStyle(.secondary)
                .font(.footnote)
                .symbolRenderingMode(.hierarchical)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .allowsHitTesting(false)
        }
        
        @ViewBuilder private var controls: some View {
            Control(title: "Find on page", symbol: "rectangle.and.text.magnifyingglass") {
                
            }
            
            Control(title: "Bookmark", symbol: "bookmark") {
                dismiss()
                Task
                    .detached {
                        await UNUserNotificationCenter.send(message: "Bookmark added!")
                        await cloud.bookmark(history: web.history)
                    }
            }
            
            Control(title: "Share", symbol: "square.and.arrow.up") {
                share.send()
            }
            .padding(.bottom)
        }
    }
}
