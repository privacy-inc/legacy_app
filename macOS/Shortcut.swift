import AppKit
import Combine

final class Shortcut: NSPopover {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(origin: NSView) {
        super.init()
        behavior = .transient
        contentSize = .init(width: 200, height: 220)
        contentViewController = .init()
        
        let view = NSView(frame: .init(origin: .zero, size: contentSize))
        contentViewController!.view = view
        
        let stats = Text(vibrancy: true)
        stats.attributedStringValue = .init(statsString)
        stats.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let close = Action(title: "Close all")
        close.state = NSApp.windowsOpen > 0 ? .on : .off
        close
            .click
            .sink { [weak self] in
                NSApp.closeAllWindows()
                self?.close()
            }
            .store(in: &subs)
        
        let forget = Option(icon: "flame.circle.fill", color: .systemPink)
        forget
            .click
            .sink {
                let pop = Forgetting(behaviour: .transient)
                pop.show(relativeTo: origin.bounds, of: origin, preferredEdge: .maxY)
                pop.contentViewController!.view.window!.makeKey()
            }
            .store(in: &subs)
        
        let stack = NSStackView(views: [forget, .init(), Separator(mode: .horizontal), stats, Separator(mode: .horizontal), close])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        view.addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        
        show(relativeTo: origin.bounds, of: origin, preferredEdge: .maxY)
    }
    
    private var statsString: AttributedString {
        .init(NSApp.windowsOpen.formatted(), attributes: .init([
            .font: NSFont.monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular),
            .foregroundColor: NSColor.labelColor]))
        + .init(NSApp.windowsOpen == 1 ? " window" : " windows", attributes: .init([
            .font: NSFont.preferredFont(forTextStyle: .body),
            .foregroundColor: NSColor.secondaryLabelColor]))
        + .newLine
        + .init(NSApp.tabsOpen.formatted(), attributes: .init([
            .font: NSFont.monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular),
            .foregroundColor: NSColor.labelColor]))
        + .init(NSApp.tabsOpen == 1 ? " tab" : " tabs", attributes: .init([
            .font: NSFont.preferredFont(forTextStyle: .body),
            .foregroundColor: NSColor.secondaryLabelColor]))
    }
}
