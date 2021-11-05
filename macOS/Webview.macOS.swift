import AppKit
import WebKit

extension Webview: WKDownloadDelegate {
    final var defaultBackground: NSColor {
        .underPageBackgroundColor
    }
    
    final func download(_: WKDownload, decideDestinationUsing: URLResponse, suggestedFilename: String) async -> URL? {
        FileManager.default.fileExists(atPath: downloads.appendingPathComponent(suggestedFilename).path)
            ? downloads.appendingPathComponent(UUID().uuidString + "_" + suggestedFilename)
            : downloads.appendingPathComponent(suggestedFilename)
    }

    final func downloadDidFinish(_: WKDownload) {
        NSWorkspace.shared.activateFileViewerSelecting([downloads])
    }

    private var downloads: URL {
        FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
    }
}
