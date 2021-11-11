import AppKit
import Combine

final class Activity: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 1000, height: 300),
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
        
        let eventsTitle = Text(vibrancy: true)
        eventsTitle.stringValue = "Events"
        
        let totalEvents = Text(vibrancy: true)
        totalEvents.stringValue = "Total events"
        
        let events = Text(vibrancy: true)
        
        let trackerEvents = Text(vibrancy: true)
        trackerEvents.stringValue = "Tracker events"
        
        let trackers = Text(vibrancy: true)
        
        let websitesTitle = Text(vibrancy: true)
        websitesTitle.stringValue = "Websites"
        
        let totalWebsites = Text(vibrancy: true)
        totalWebsites.stringValue = "Total websites"
        
        let websites = Text(vibrancy: true)
        
        let mostVisited = Text(vibrancy: true)
        mostVisited.stringValue = "Most visited"
        
        let icon = Icon(size: 24)
        
        let visited = Text(vibrancy: true)
        
        let trackersTitle = Text(vibrancy: true)
        trackersTitle.stringValue = "Trackers"
        
        let totalTrackers = Text(vibrancy: true)
        totalTrackers.stringValue = "Total trackers"
        
        let prevented = Text(vibrancy: true)
        
        let mostPrevented = Text(vibrancy: true)
        mostPrevented.stringValue = "Most prevented"
        
        let most = Text(vibrancy: true)
        
        [eventsTitle, websitesTitle, trackersTitle]
            .forEach {
                $0.font = .preferredFont(forTextStyle: .title3)
                $0.textColor = .tertiaryLabelColor
            }
        
        [totalEvents, trackerEvents, totalWebsites, mostVisited, totalTrackers, mostPrevented]
            .forEach {
                $0.font = .preferredFont(forTextStyle: .footnote)
                $0.textColor = .secondaryLabelColor
            }
        
        [events, trackers, websites, prevented, most]
            .forEach {
                $0.font = .monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular)
                $0.textColor = .labelColor
            }
        
        [visited, prevented]
            .forEach {
                $0.font = .preferredFont(forTextStyle: .body)
                $0.textColor = .labelColor
            }
        
        let stackEvents = NSStackView(views: [
            eventsTitle,
            Separator(mode: .horizontal),
            totalEvents,
            events,
            Separator(mode: .horizontal),
            trackerEvents,
            trackers])
        
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
        
        [stackEvents, stackWebsites, stackTrackers]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.orientation = .vertical
                $0.alignment = .leading
                content.addSubview($0)
                
                $0.topAnchor.constraint(equalTo: card.topAnchor).isActive = true
                $0.bottomAnchor.constraint(equalTo: card.bottomAnchor).isActive = true
                $0.widthAnchor.constraint(equalToConstant: 190).isActive = true
            }
        
        title.centerYAnchor.constraint(equalTo: content.topAnchor, constant: 26).isActive = true
        title.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -26).isActive = true
        
        card.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        card.leftAnchor.constraint(equalTo: content.leftAnchor, constant: 30).isActive = true
        card.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -30).isActive = true
        
        stackEvents.rightAnchor.constraint(equalTo: stackWebsites.leftAnchor, constant: -20).isActive = true
        stackWebsites.rightAnchor.constraint(equalTo: stackTrackers.leftAnchor, constant: -20).isActive = true
        stackTrackers.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -30).isActive = true
        
        cloud
            .map(\.events)
            .sink {
                let stats = $0.stats
                let since = $0.since ?? .now
                
                title.attributedStringValue = .init(
                    .init("Activity since ", attributes: .init([
                        .foregroundColor: NSColor.labelColor]))
                    + .init(since.formatted(.relative(presentation: .named, unitsStyle: .wide)), attributes: .init([
                        .foregroundColor: NSColor.secondaryLabelColor])))
                
                events.stringValue = stats.websites.formatted()
                trackers.stringValue = $0.prevented.formatted()
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
