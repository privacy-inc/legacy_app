import AppKit

final class Preferences: NSWindow {
    init() {
        let controller = Controller()
        super.init(contentRect: .init(x: 0, y: 0, width: 600, height: 600),
                   styleMask: [.closable, .titled], backing: .buffered, defer: true)
        animationBehavior = .alertPanel
        isReleasedWhenClosed = false
        contentViewController = controller
        controller.tabView(controller.tabView, willSelect: controller.tabViewItems.first)
        center()
        setFrameAutosaveName("Preferences")
    }
}
