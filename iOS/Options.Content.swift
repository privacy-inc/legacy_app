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
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.quaternary)
                    }
                    
                    navigation
                }
                heading
                connection
                
                Spacer()
                
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
            .padding()
            .background(.regularMaterial)
            .onReceive(web.publisher(for: \.isLoading)) { value in
                withAnimation(.easeInOut(duration: 0.6)) {
                    loading = value
                }
            }
            .onReceive(web.publisher(for: \.url)) { value in
                url = value
                update()
            }
            .onReceive(web.publisher(for: \.title)) { value in
                title = value ?? ""
            }
            .onReceive(web.publisher(for: \.canGoBack)) { value in
                withAnimation(.easeInOut(duration: 0.3)) {
                    backwards = value
                }
            }
            .onReceive(web.publisher(for: \.canGoForward)) { value in
                withAnimation(.easeInOut(duration: 0.3)) {
                    forwards = value
                }
            }
        }
        
        private func update() {
            publisher = nil
            access = nil
            
            Task {
                access = await cloud.website(history: web.history).access
                if let access = access {
                    publisher = await favicon.publisher(for: access)
                }
            }
        }
        
        private var navigation: some View {
            HStack {
                if let publisher = publisher, let access = access {
                    Icon(size: 48, access: access, publisher: publisher)
                        .id(access.value)
                }
                
                Action(symbol: loading ? "xmark" : "arrow.clockwise", active: true) {
                    if loading {
                        web.stopLoading()
                    } else {
                        web.reload()
                        dismiss()
                    }
                }
                .padding(.leading)
                
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
        
        private var heading: some View {
            Text(verbatim: title)
                .foregroundStyle(.secondary)
                .font(.callout)
                .padding(.vertical, 4)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .allowsHitTesting(false)
        }
        
        private var connection: some View {
            Group {
                if let url = url {
                    switch url.scheme?.lowercased() {
                    case "https":
                        Label(url.absoluteString, systemImage: "lock.fill")
                    case "http":
                        Label(url.absoluteString, systemImage: "exclamationmark.triangle.fill")
                    default:
                        Text(verbatim: url.absoluteString)
                    }
                }
            }
            .foregroundStyle(.tertiary)
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            .font(.footnote)
            .symbolRenderingMode(.hierarchical)
            .imageScale(.large)
            .lineLimit(2)
            .allowsHitTesting(false)
        }
    }
}
