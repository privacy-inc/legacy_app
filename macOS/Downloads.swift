import AppKit

final class Downloads: NSVisualEffectView {
    required init?(coder: NSCoder) { nil }
    init(status: Status) {
        super.init(frame: .zero)
        state = .active
        material = .menu
    }
    
    /*
     @MainActor private func save(data: Data, name: String, types: [UTType]) {
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
     */
}
