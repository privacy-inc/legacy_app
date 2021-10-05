import SwiftUI
import Specs

extension Options {
    struct Content: View {
        let web: Web
        @State private var loading = false
        @State private var title = ""
        @State private var url: URL?
        @State private var access: AccessType?
        @State private var publisher: Favicon.Pub?
        @State private var backwards = false
        @State private var forwards = false
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            VStack {
                HStack {
                    Spacer()
                    
                    Button("Dismiss") {
                        dismiss()
                    }
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
                    .padding([.top, .trailing])
                }
                heading
                Spacer()
                options
                Spacer()
                controls
            }
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
                guard let access = await cloud.model.history.first(where: { $0.id == web.history })?.website.access else { return }
                self.access = access
                publisher = await favicon.publisher(for: access)
            }
        }
        
        private var heading: some View {
            VStack {
                if let publisher = publisher, let access = access {
                    Icon(access: access, publisher: publisher)
                        .padding(.bottom)
                        .id(access.value)
                }
            
                switch url?.scheme?.lowercased() {
                case "https":
                    Text("\(Image(systemName: "lock.fill")) Secure connection")
                        .font(.caption)
                        .imageScale(.small)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                case "http":
                    Text("\(Image(systemName: "exclamationmark.triangle.fill")) Connection not secure")
                        .font(.caption)
                        .foregroundStyle(.primary)
                        .symbolRenderingMode(.hierarchical)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                default:
                    EmptyView()
                }
                
                Text(verbatim: title)
                    .foregroundStyle(.primary)
                    .font(.callout)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                
                Text(verbatim: url?.absoluteString ?? "")
                    .foregroundStyle(.tertiary)
                    .font(.footnote)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 40)
            .allowsHitTesting(false)
        }
        
        private var controls: some View {
            HStack(spacing: 30) {
                Spacer()
                
                Button {
                    web.goBack()
                    update()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.callout.weight(.medium))
                        .frame(width: 40, height: 40)
                        .foregroundStyle(backwards ? .primary : .quaternary)
                        .allowsHitTesting(false)
                }
                .allowsHitTesting(backwards)
                
                Button {
                    if loading {
                        web.stopLoading()
                    } else {
                        web.reload()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(loading ? Color("Dawn") : .init("Shades"))
                        Image(systemName: loading ? "xmark" : "arrow.clockwise")
                            .font(.footnote.weight(.bold))
                            .foregroundColor(.init(.systemBackground))
                    }
                    .frame(width: 50, height: 40)
                    .allowsHitTesting(false)
                }
                
                Button {
                    web.goForward()
                    update()
                } label: {
                    Image(systemName: "chevron.forward")
                        .font(.callout.weight(.medium))
                        .frame(width: 40, height: 40)
                        .foregroundStyle(forwards ? .primary : .quaternary)
                        .allowsHitTesting(false)
                }
                .allowsHitTesting(forwards)
                
                Spacer()
            }
            .padding(.bottom, 30)
        }
        
        private var options: some View {
            HStack(spacing: 60) {
                Spacer()
                
                Control(title: "Find", symbol: "rectangle.and.text.magnifyingglass") {
                    
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
                    
                }
                
                Spacer()
            }
            .symbolRenderingMode(.hierarchical)
        }
    }
}