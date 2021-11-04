import AppKit
import UniformTypeIdentifiers

extension NSSavePanel {
    class func save(data: Data, name: String, types: [UTType]) {
        let panel = Self()
        panel.nameFieldStringValue = name
        panel.allowedContentTypes = types
        panel.begin {
            if $0 == .OK, let url = panel.url {
                try? data.write(to: url, options: .atomic)
                NSWorkspace.shared.activateFileViewerSelecting([url])
            }
        }
    }
}
