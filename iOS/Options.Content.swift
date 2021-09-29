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
            NavigationView {
                List {
                    heading
                    options
                }
                .listStyle(.insetGrouped)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        switch url?.scheme?.lowercased() {
                        case "https":
                            Text("\(Image(systemName: "lock.fill")) Secure connection")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        case "http":
                            Text("\(Image(systemName: "exclamationmark.triangle.fill")) Insecure connection")
                                .symbolRenderingMode(.hierarchical)
                                .font(.footnote)
                                .foregroundStyle(.primary)
                        default:
                            EmptyView()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if loading {
                            Button {
                                dismiss()
                            } label: {
                                Text("Stop \(Image(systemName: "xmark"))")
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.init("Dawn"))
                            .font(.footnote)
                        } else {
                            Button {
                                dismiss()
                            } label: {
                                Text("Reload \(Image(systemName: "arrow.clockwise"))")
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.init("Shades"))
                            .font(.footnote)
                        }
                    }
                }
            }
            .navigationViewStyle(.stack)
            .onReceive(web.publisher(for: \.isLoading)) {
                loading = $0
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
            VStack(spacing: 5) {
                if let publisher = publisher {
                    Icon(access: access!, publisher: publisher)
                        .padding(.bottom)
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
    }
}
