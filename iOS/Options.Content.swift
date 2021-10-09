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
            VStack {
                HStack {
                    switch url?.scheme?.lowercased() {
                    case "https":
                        Label("Secure connection", systemImage: "lock.fill")
                            .font(.caption)
                            .foregroundStyle(.primary)
                    case "http":
                        Text("\(Image(systemName: "exclamationmark.triangle.fill")) Connection not secure")
                            .font(.footnote)
                            .foregroundStyle(.primary)
                            .symbolRenderingMode(.hierarchical)
                    default:
                        EmptyView()
                    }
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding([.top, .leading, .trailing])
                heading
                Spacer()
                controls
            }
            .background(.regularMaterial)
            .safeAreaInset(edge: .bottom) {
                options
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
                access = await cloud.website(history: web.history).access
                publisher = await favicon.publisher(for: access!)
            }
        }
        
        private var heading: some View {
            VStack {
                if let publisher = publisher, let access = access {
                    Icon(access: access, publisher: publisher)
                        .padding(.bottom)
                        .id(access.value)
                }
                
                Text(verbatim: title)
                    .foregroundStyle(.primary)
                    .font(.callout)
                Text(verbatim: url?.absoluteString ?? "")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 30)
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
                        dismiss()
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
            .padding(.bottom, 50)
        }
        
        private var options: some View {
            HStack {
                Control(title: "Find", symbol: "rectangle.and.text.magnifyingglass") {
                    
                }
                .padding(.leading, 40)
                
                Spacer()
                
                Control(title: "Bookmark", symbol: "bookmark") {
                    dismiss()
                    Task
                        .detached {
                            await UNUserNotificationCenter.send(message: "Bookmark added!")
                            await cloud.bookmark(history: web.history)
                        }
                }
                
                Spacer()
                
                Control(title: "Share", symbol: "square.and.arrow.up") {
                    share.send()
                }
                .padding(.trailing, 40)
            }
            .symbolRenderingMode(.hierarchical)
        }
    }
}
