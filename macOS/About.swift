import AppKit

final class About: NSWindow {
    init() {
        super.init(contentRect: .init(x: 0,
                                      y: 0,
                                      width: 300,
                                      height: 200),
                   styleMask: [.closable, .miniaturizable, .titled, .fullSizeContentView],
                   backing: .buffered,
                   defer: false)
        toolbar = .init()
        isReleasedWhenClosed = false
//        setFrameAutosaveName("Window")
        tabbingMode = .disallowed
        titlebarAppearsTransparent = true
    }
}
