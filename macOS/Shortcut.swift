import AppKit
import Combine

final class Shortcut: NSPopover {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(origin: NSView) {
        super.init()
        behavior = .transient
        contentSize = .init(width: 200, height: 300)
        contentViewController = .init()
        
        let view = NSView(frame: .init(origin: .zero, size: contentSize))
        contentViewController!.view = view
        
        let stats = Text(vibrancy: true)
        stats.attributedStringValue = .init(statsString)
        stats.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.addSubview(stats)
        
        let close = Action(title: "Close all", color: .systemIndigo, foreground: .white)
        close.state = NSApp.windowsOpen > 0 ? .on : .off
        close
            .click
            .sink { [weak self] in
                NSApp.closeAllWindows()
                self?.close()
            }
            .store(in: &subs)
        view.addSubview(close)
        
        let forget = Option(icon: "flame.circle.fill", color: .systemPink)
        forget
            .click
            .sink {
                let pop = Forgeting()
                pop.show(relativeTo: origin.bounds, of: origin, preferredEdge: .maxY)
                pop.contentViewController!.view.window!.makeKey()
            }
            .store(in: &subs)
        view.addSubview(forget)
        
        stats.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        stats.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        stats.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -30).isActive = true
        
        close.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        close.topAnchor.constraint(equalTo: stats.bottomAnchor, constant: 20).isActive = true
        
        forget.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        forget.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        show(relativeTo: origin.bounds, of: origin, preferredEdge: .maxY)
    }
    
    private var statsString: AttributedString {
        .init("Windows open", attributes: .init([
            .font: NSFont.preferredFont(forTextStyle: .body),
            .foregroundColor: NSColor.tertiaryLabelColor]))
        + .newLine
        + .init(NSApp.windowsOpen.formatted() + "\n\n", attributes: .init([
            .font: NSFont.monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular),
            .foregroundColor: NSColor.secondaryLabelColor]))
        + .init("Tabs open", attributes: .init([
            .font: NSFont.preferredFont(forTextStyle: .callout),
            .foregroundColor: NSColor.tertiaryLabelColor]))
        + .newLine
        + .init(NSApp.tabsOpen.formatted(), attributes: .init([
            .font: NSFont.monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular),
            .foregroundColor: NSColor.secondaryLabelColor]))
    }
}
