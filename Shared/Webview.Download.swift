import WebKit
import Sleuth

@available(macOS 12, iOS 14.5, *) extension Webview: WKDownloadDelegate {
    func webView(_: WKWebView, navigationAction: WKNavigationAction, didBecome: WKDownload) {
        didBecome.delegate = self
    }
    
    func webView(_: WKWebView, navigationResponse: WKNavigationResponse, didBecome: WKDownload) {
        didBecome.delegate = self
    }
    
    func download(_ download: WKDownload, didFailWithError: Error, resumeData: Data?) {
        error(url: download.originalRequest?.url, description: (didFailWithError as NSError).localizedDescription)
    }
    
    #if os(macOS)
    
    func download(_: WKDownload, decideDestinationUsing: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
        let url: URL
        if FileManager.default.fileExists(atPath: downloads.appendingPathComponent(suggestedFilename).path) {
            url = downloads.appendingPathComponent(UUID().uuidString + "_" + suggestedFilename)
        } else {
            url = downloads.appendingPathComponent(suggestedFilename)
        }
        completionHandler(url)
    }
    
    func downloadDidFinish(_: WKDownload) {
        NSWorkspace.shared.activateFileViewerSelecting([downloads])
    }
    
    private var downloads: URL {
        FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
    }
    
    #elseif os(iOS)
    
    func download(_ download: WKDownload, decideDestinationUsing: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
        decideDestinationUsing
            .url
            .map {
                try? UIApplication.shared.share(Data(contentsOf: $0).temporal(suggestedFilename))
            }
        download.cancel(nil)
        completionHandler(nil)
    }
    
    #endif
}
