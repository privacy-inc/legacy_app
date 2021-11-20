import AppKit
import Combine

final class Activity: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 550, height: 500),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        animationBehavior = .alertPanel
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .menu
        contentView = content
        center()
        setFrameAutosaveName("Activity")
        
        let title = Text(vibrancy: true)
        title.font = .preferredFont(forTextStyle: .body)
        content.addSubview(title)
        
        let card = Card()
        content.addSubview(card)
        
        let events = Text(vibrancy: true)
        content.addSubview(events)
        
        let websitesTitle = Text(vibrancy: true)
        websitesTitle.stringValue = "Websites"
        
        let totalWebsites = Text(vibrancy: true)
        totalWebsites.stringValue = "Total"
        
        let websites = Text(vibrancy: true)
        
        let mostVisited = Text(vibrancy: true)
        mostVisited.stringValue = "Most visited"
        
        let icon = Icon(size: 24)
        
        let visited = Text(vibrancy: true)
        
        let trackersTitle = Text(vibrancy: true)
        trackersTitle.stringValue = "Trackers"
        
        let totalTrackers = Text(vibrancy: true)
        totalTrackers.stringValue = "Total"
        
        let prevented = Text(vibrancy: true)
        
        let mostPrevented = Text(vibrancy: true)
        mostPrevented.stringValue = "Most prevented"
        
        let most = Text(vibrancy: true)
        
        [websitesTitle, trackersTitle]
            .forEach {
                $0.font = .preferredFont(forTextStyle: .title3)
                $0.textColor = .tertiaryLabelColor
            }
        
        [totalWebsites, mostVisited, totalTrackers, mostPrevented]
            .forEach {
                $0.font = .preferredFont(forTextStyle: .footnote)
                $0.textColor = .secondaryLabelColor
            }
        
        [websites, prevented]
            .forEach {
                $0.font = .monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular)
                $0.textColor = .labelColor
            }
        
        [visited, most]
            .forEach {
                $0.font = .preferredFont(forTextStyle: .body)
                $0.textColor = .labelColor
            }
        
        let stackWebsites = NSStackView(views: [
            websitesTitle,
            Separator(mode: .horizontal),
            totalWebsites,
            websites,
            Separator(mode: .horizontal),
            mostVisited,
            icon,
            visited
        ])
        
        let stackTrackers = NSStackView(views: [
            trackersTitle,
            Separator(mode: .horizontal),
            totalTrackers,
            prevented,
            Separator(mode: .horizontal),
            mostPrevented,
            most])
        
        [stackWebsites, stackTrackers]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.orientation = .vertical
                $0.alignment = .leading
                content.addSubview($0)
                
                $0.topAnchor.constraint(equalTo: card.bottomAnchor, constant: 30).isActive = true
            }
        
        title.centerYAnchor.constraint(equalTo: content.topAnchor, constant: 26).isActive = true
        title.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -26).isActive = true
        
        card.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor).isActive = true
        card.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -30).isActive = true
        card.heightAnchor.constraint(equalToConstant: 210).isActive = true
        
        events.topAnchor.constraint(equalTo: card.topAnchor, constant: 20).isActive = true
        events.rightAnchor.constraint(equalTo: card.leftAnchor, constant: -30).isActive = true
        
        stackWebsites.leftAnchor.constraint(equalTo: content.leftAnchor, constant: 40).isActive = true
        stackWebsites.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        stackTrackers.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -40).isActive = true
        stackTrackers.widthAnchor.constraint(equalToConstant: 270).isActive = true
        
        cloud
            .map(\.events)
            .sink {
                let stats = $0.stats
                let since = $0.since ?? .now
                let attempts = $0.prevented.formatted()
                
                title.attributedStringValue = .make {
                    $0.append(.make("Activity since ", attributes: [
                        .foregroundColor: NSColor.tertiaryLabelColor]))
                    $0.append(.make(since.formatted(.relative(presentation: .named, unitsStyle: .wide)), attributes: [
                            .foregroundColor: NSColor.labelColor]))
                }
                
                events.attributedStringValue = .make(alignment: .right) {
                    $0.append(.make(stats.websites.formatted(), attributes: [
                        .foregroundColor: NSColor.labelColor,
                        .font: NSFont.monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .title1).pointSize, weight: .light)]))
                    $0.newLine()
                    $0.append(.make("Web pages visited", attributes: [
                        .foregroundColor: NSColor.tertiaryLabelColor,
                        .font: NSFont.preferredFont(forTextStyle: .body)]))
                    $0.newLine()
                    $0.newLine()
                    $0.append(.make(attempts, attributes: [
                        .foregroundColor: NSColor.labelColor,
                        .font: NSFont.monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .title1).pointSize, weight: .light)]))
                    $0.newLine()
                    $0.append(.make("Trackings prevented", attributes: [
                        .foregroundColor: NSColor.tertiaryLabelColor,
                        .font: NSFont.preferredFont(forTextStyle: .body)]))
                }
                
                websites.stringValue = (stats.domains?.count ?? 0).formatted()
                icon.icon(icon: stats.domains?.top.lowercased())
                visited.stringValue = stats.domains?.top ?? ""
                prevented.stringValue = (stats.trackers?.count ?? 0).formatted()
                most.stringValue = stats.trackers?.top ?? ""
            }
            .store(in: &subs)
    }
    
    @objc func triggerCloseTab() {
        close()
    }
}
