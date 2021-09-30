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
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            List {
                heading
                controls
                options
            }
            .listStyle(.insetGrouped)
            .onReceive(web.publisher(for: \.isLoading)) { value in
                withAnimation(.easeInOut(duration: 0.3)) {
                    loading = value
                }
            }
            .onReceive(web.publisher(for: \.url)) {
                url = $0
                publisher = nil
                update()
            }
            .onReceive(web.publisher(for: \.title)) {
                title = $0 ?? ""
            }
        }
        
        private func update() {
            Task {
                guard let access = await cloud.model.history.first(where: { $0.id == web.history })?.website.access else { return }
                self.access = access
                publisher = await favicon.publisher(for: access)
            }
        }
        
        private var heading: some View {
            VStack {
                if let publisher = publisher {
                    Icon(access: access!, publisher: publisher)
                        .padding(.bottom)
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
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        
        private var options: some View {
            Section {
                Button {
                    
                } label: {
                    HStack {
                        Text("Share")
                            .font(.footnote)
                        Spacer()
                        Image(systemName: "square.and.arrow.up")
                            .font(.callout)
                            .frame(width: 24)
                    }
                }
                
                Button {
                    
                } label: {
                    HStack {
                        Text("Bookmark")
                            .font(.footnote)
                        Spacer()
                        Image(systemName: "bookmark.fill")
                            .font(.callout)
                            .frame(width: 24)
                    }
                }
                
                Button {
                    
                } label: {
                    HStack {
                        Text("Find on page")
                            .font(.footnote)
                        Spacer()
                        Image(systemName: "rectangle.and.text.magnifyingglass")
                            .font(.callout)
                            .frame(width: 24)
                    }
                }
            }
            .symbolRenderingMode(.hierarchical)
        }
        
        private var controls: some View {
            Section {
                HStack {
                    Spacer()
                    Button {
                        if loading {
                            web.stopLoading()
                        } else {
                            web.reload()
                        }
                    } label: {
                        ZStack {
                            if loading {
                                Capsule()
                                    .fill(Color("Dawn"))
                                Image(systemName: "xmark")
                                    
                            } else {
                                Capsule()
                                    .fill(Color("Shades"))
                                Image(systemName: "arrow.clockwise")
                            }
                        }
                        .font(.footnote.weight(.medium))
                        .foregroundColor(.init(.systemBackground))
                        .frame(width: 40, height: 40)
                    }
                    Spacer()
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
    }
}
