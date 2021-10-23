import SwiftUI
import Combine
import Specs

extension Options {
    struct Content: View {
        let web: Web
        let share: PassthroughSubject<Void, Never>
        let find: () -> Void
        @State private var access: AccessType?
        @State private var publisher: Favicon.Pub?
        @State private var size = CGFloat(1)
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            ScrollView(showsIndicators: false) {
                icon
                navigation
                Divider()
                    .padding(.horizontal)
                font
                controls
                Spacer()
                    .frame(height: 30)
            }
            .background(.thickMaterial)
            .onReceive(web.publisher(for: \.url)) { _ in
                publisher = nil
                access = nil
                
                Task {
                    access = await cloud.website(history: web.history)?.access
                    if let access = access, let publisher = await favicon.publisher(for: access) {
                        update(publisher: publisher)
                    }
                }
                
                DispatchQueue
                    .main
                    .asyncAfter(deadline: .now() + 0.1) {
                        Task {
                            await update()
                        }
                    }
            }
        }
        
        @MainActor private func update() async {
            guard
                let string = try? await web.evaluateJavaScript(Script.text.script) as? String,
                let int = Int(string.replacingOccurrences(of: "%", with: ""))
            else {
                size = 1
                return
            }
            size = .init(int) / 100
        }
        
        private func update(publisher: Favicon.Pub) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.publisher = publisher
            }
        }
        
        private var icon: some View {
            HStack {
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
                
                if let url = web.url {
                    address(url: url)
                }
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 40)
                        .allowsHitTesting(false)
                }
                .frame(width: 50)
            }
            .padding(.leading)
            .frame(height: 100)
        }
        
        private var navigation: some View {
            HStack(spacing: 20) {
                Action(symbol: "chevron.backward", active: web.canGoBack) {
                    web.goBack()
                }
                
                Action(symbol: web.isLoading ? "xmark" : "arrow.clockwise", active: true) {
                    if web.isLoading {
                        web.stopLoading()
                    } else {
                        web.reload()
                        dismiss()
                    }
                }
                
                Action(symbol: "chevron.forward", active: web.canGoForward) {
                    web.goForward()
                }
            }
            .tint(.init("Shades"))
            .padding(.bottom)
        }
        
        private func address(url: URL) -> some View {
            VStack(alignment: .leading) {
                Text(verbatim: web.title ?? url.host ?? "")
                    .foregroundStyle(.primary)
                    .font(.footnote)
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
                .font(.footnote)
                .foregroundStyle(.secondary)
                .symbolRenderingMode(.hierarchical)
            }
            .lineLimit(1)
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            .allowsHitTesting(false)
        }
        
        @ViewBuilder private var controls: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground))
                    .shadow(color: .init(white: 0, opacity: 0.1), radius: 2)
                Toggle("Disable text selection", isOn: .init(get: {
                    !web.configuration.preferences.isTextInteractionEnabled
                }, set: {
                    web.configuration.preferences.isTextInteractionEnabled = !$0
                }))
                .toggleStyle(SwitchToggleStyle(tint: .init("Shades")))
                .font(.callout)
                .padding(.horizontal)
            }
            .padding(.horizontal)
            .frame(height: 50)
            .padding(.top, 30)
            
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
            
            Control(title: "Pause all media", symbol: "pause.circle.fill") {
                dismiss()
                Task {
                    await MainActor
                        .run {
                            Task {
                                await web.pauseAllMediaPlayback()
                            }
                        }
                }
            }
        }
        
        private var font: some View {
            HStack {
                Action(symbol: "textformat.size.smaller", active: size > 0.25) {
                    size -= 0.25
                    Task {
                        await resize()
                    }
                }
                .tint(.init("Dawn"))
                
                Button {
                    size = 1
                    Task {
                        await resize()
                    }
                } label: {
                    Text(size, format: .percent)
                        .font(.callout)
                        .foregroundStyle(.primary)
                        .frame(width: 70, height: 40)
                        .allowsHitTesting(false)
                }
                
                Action(symbol: "textformat.size.larger", active: size < 4) {
                    size += 0.25
                    Task {
                        await resize()
                    }
                }
                .tint(.init("Dawn"))
            }
            .padding()
        }
        
        @MainActor private func resize() async {
            _ = try? await web.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='\(Int(size * 100))%'")
        }
    }
}
