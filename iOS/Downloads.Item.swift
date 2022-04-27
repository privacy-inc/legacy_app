import SwiftUI
import WebKit

extension Downloads {
    struct Item: View {
        let session: Session
        let download: WKDownload
        let status: Status
        @State private var progress = Double()
        @State private var title = ""
        @State private var weight = ""
        @State private var finished = false
        
        var body: some View {
            HStack {
                Text(finished ? download.progress.fileURL?.lastPathComponent ?? title : title)
                    .lineLimit(1)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)

                VStack(alignment: .trailing, spacing: 2) {
                    Text(weight)
                        .font(.caption2.monospacedDigit())
                        .lineLimit(1)
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.primary.opacity(0.1))
                        Capsule()
                            .fill(.blue)
                            .frame(width: progress * 150)
                    }
                    .frame(height: 6)
                }
                .frame(width: 150)
                
                Button {
                    if finished {
                        download
                            .progress
                            .fileURL
                            .map(UIApplication.shared.share)
                    } else if status == .on {
                        session
                            .downloads
                            .remove {
                                $0.download == download
                            }
                        Task {
                            if let data = await download.cancel() {
                                session.downloads.append((download: download, status: .cancelled(data)))
                            }
                        }
                    } else if case let .cancelled(data) = status {
                        session
                            .downloads
                            .remove {
                                $0.download == download
                            }
                        
                        Task {
                            if let resumed = await download.webView?.resumeDownload(fromResumeData: data) {
                                resumed.delegate = download.webView as? Web
                                resumed.progress.fileURL = download.progress.fileURL
                                session.downloads.append((download: resumed, status: .on))
                            }
                        }
                    }
                } label: {
                    Image(systemName: finished
                          ? "magnifyingglass.circle.fill"
                          : status == .on
                              ? "xmark.circle.fill"
                              : "arrow.clockwise.circle.fill")
                    .font(.system(size: 24, weight: .light))
                    .symbolRenderingMode(.hierarchical)
                    .padding(8)
                    .contentShape(Rectangle())
                }
                .tint(finished
                      ? .blue
                      : status == .on
                          ? .pink
                          : .mint)
            }
            .padding(.horizontal)
            .onReceive(download.progress.publisher(for: \.isFinished)) {
                finished = $0
            }
            .onReceive(download.progress.publisher(for: \.fractionCompleted)) {
                progress = $0
            }
            .onReceive(download.progress.publisher(for: \.localizedDescription)) {
                title = $0
            }
            .onReceive(download.progress.publisher(for: \.localizedAdditionalDescription)) {
                weight = $0
            }
        }
    }
}
