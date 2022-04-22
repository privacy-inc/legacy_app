import SwiftUI

extension Detail {
    struct Header: View {
        let status: Browser.Status
        let web: Web
        @State private var title = ""
        @State private var url: URL?
        @State private var secure = false
        @State private var trackers = false
        @State private var counter = 0
        @StateObject private var icon = Icon()
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    if let image = icon.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                            .frame(width: 50, height: 50)
                            .padding(.top, 50)
                    } else {
                        Spacer()
                            .frame(height: 20)
                    }
                    
                    if let domain = url?.absoluteString.domain {
                        HStack(spacing: 4) {
                            Text(domain)
                                .font(.callout)
                            Image(systemName: secure ? "lock.fill" : "exclamationmark.triangle.fill")
                                .foregroundStyle(.secondary)
                                .font(.footnote)
                        }
                        .padding(.vertical)
                    }
                    
                    Button {
                        trackers = true
                    } label: {
                        HStack {
                            Image(systemName: "bolt.shield")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 20, weight: .light))
                            Text(counter, format: .number)
                                .font(.callout.monospacedDigit())
                        }
                        .contentShape(Rectangle())
                    }
                    .foregroundColor(counter == 0 ? Color.secondary : Color(.systemBackground))
                    .tint(counter == 0 ? .clear : .primary)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .allowsHitTesting(counter != 0)
                    .sheet(isPresented: $trackers, onDismiss: {
                        dismiss()
                    }) {
                        Trackers(domain: url?.absoluteString.domain ?? "")
                    }
                }
                
                HStack {
                    Button {
                        status.share.send()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 18, weight: .regular))
                            .padding(18)
                            .contentShape(Rectangle())
                    }
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .light))
                            .padding(18)
                            .contentShape(Rectangle())
                    }
                    .foregroundStyle(.secondary)
                }
                .symbolRenderingMode(.hierarchical)
            }
            .onReceive(web.publisher(for: \.url)) {
                url = $0
            }
            .onReceive(web.publisher(for: \.title)) {
                title = $0 ?? ""
            }
            .onReceive(web.publisher(for: \.hasOnlySecureContent)) {
                secure = $0
            }
            .onReceive(cloud) {
                if let domain = url?.absoluteString.domain {
                    counter = $0.tracking.count(domain: domain)
                }
            }
            .onChange(of: url) { url in
                Task {
                    await icon.load(website: url)
                    
                    if let domain = url?.absoluteString.domain {
                        counter = await cloud.model.tracking.count(domain: domain)
                    }
                }
            }
            .task {
                await icon.load(website: url)
            }
        }
    }
}
