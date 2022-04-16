import SwiftUI

extension Detail {
    struct Content: View {
        @ObservedObject var status: Status
        let web: Web
        @State private var title = ""
        @State private var url: URL?
        @State private var back = false
        @State private var forward = false
        @State private var loading = false
        @State private var secure = false
        @State private var selectable = true
        @State private var reader = true
        @State private var find = true

        var body: some View {
            ScrollView(showsIndicators: false) {
                Header(url: url, title: title, secure: secure)

                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.tertiarySystemBackground))
                    VStack(spacing: 0) {
                        Action(title: "Share", icon: "square.and.arrow.up") {
                            
                        }
                        
                        Divider()
                        
                        Action(title: "Bookmark", icon: "bookmark") {
                            
                        }
                        
                        Divider()
                        
                        Action(title: "Pause all media", icon: "pause") {
                            
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.tertiarySystemBackground))
                    VStack(spacing: 0) {
                        Switch(icon: "textformat.size", title: "Reader", value: $reader)
                            .onChange(of: reader) {
                                web.session.reader(id: web.id, value: $0)
                            }
                        
                        Divider()
                        
                        Switch(icon: "doc.text.magnifyingglass", title: "Find on page", value: $find)
                            .onChange(of: find) {
                                web.session.find(id: web.id, value: $0)
                            }
                        
                        Divider()
                        
                        Switch(icon: "selection.pin.in.out", title: "Text is selectable", value: $selectable)
                            .onChange(of: selectable) {
                                guard $0 != web.configuration.preferences.isTextInteractionEnabled else { return }
                                web.configuration.preferences.isTextInteractionEnabled = $0
                            }
                    }
                    .padding(.horizontal, 20)
                    .toggleStyle(SwitchToggleStyle(tint: .init("Shades")))
                }
                .padding(.horizontal)
                .padding(.top)
                
                Spacer()
                    .frame(height: 30)
            }
            .clipped()
            .safeAreaInset(edge: .bottom, spacing: 0) {
                if status.small {
                    VStack(spacing: 0) {
                        Divider()
                        HStack {
                            Button("Lol") {
                                
                            }
                            
                        }
                        .padding(.vertical, 10)
                    }
                }
            }
            .background(.regularMaterial)
            .task {
                selectable = web.configuration.preferences.isTextInteractionEnabled
                let item = web.session.item(for: web.id)
                reader = item.reader
                find = item.find
            }
            .onReceive(web.publisher(for: \.url)) {
                url = $0
//
//                DispatchQueue
//                    .main
//                    .asyncAfter(deadline: .now() + 0.1) {
//                        Task {
//                            await updateFont()
//                        }
//                    }
            }
            .onReceive(web.publisher(for: \.title)) {
                title = $0 ?? ""
            }
            .onReceive(web.publisher(for: \.canGoBack)) {
                back = $0
            }
            .onReceive(web.publisher(for: \.canGoForward)) {
                forward = $0
            }
            .onReceive(web.publisher(for: \.isLoading)) {
                loading = $0
            }
            .onReceive(web.publisher(for: \.hasOnlySecureContent)) {
                secure = $0
            }
        }
    }
}
