import WebKit

extension Webview: WKDownloadDelegate {
    final func download(_ download: WKDownload, decideDestinationUsing: URLResponse, suggestedFilename: String) async -> URL? {
        decideDestinationUsing
            .url
            .map {
                try? UIApplication.shared.share(Data(contentsOf: $0).temporal(suggestedFilename))
            }
        
        await download.cancel()
        return nil
    }
}
