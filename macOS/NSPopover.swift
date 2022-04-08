import AppKit

extension NSPopover {
    func show(_ view: NSView, from: NSView, edge: NSRectEdge) {
        behavior = .transient
        contentSize = view.frame.size
        contentViewController = .init()
        contentViewController!.view = view
        show(relativeTo: from.bounds, of: from, preferredEdge: edge)
        contentViewController!.view.window!.makeKey()
    }
}
