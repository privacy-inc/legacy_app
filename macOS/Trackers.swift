import AppKit
import Combine

private let width = CGFloat(280)

final class Trackers: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(domain: CurrentValueSubject<String, Never>) {
        super.init(frame: .init(origin: .zero, size: .init(width: width, height: 350)))
        
        let title = Text(vibrancy: false)
        title.font = .systemFont(ofSize: 45, weight: .light)
        title.textColor = .labelColor
        addSubview(title)
        
        let url = Text(vibrancy: false)
        url.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular)
        url.textColor = .tertiaryLabelColor
        url.maximumNumberOfLines = 1
        url.lineBreakMode = .byTruncatingTail
        addSubview(url)
        
        let icon = NSImageView(image: .init(systemSymbolName: "shield.lefthalf.filled", accessibilityDescription: nil) ?? .init())
        icon.symbolConfiguration = .init(pointSize: 20, weight: .light)
            .applying(.init(hierarchicalColor: .tertiaryLabelColor))
        icon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(icon)
        
        let description = Text(vibrancy: false)
        description.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .footnote).pointSize, weight: .regular)
        description.textColor = .tertiaryLabelColor
        description.stringValue = "Trackers prevented\non this website"
        description.maximumNumberOfLines = 2
        addSubview(description)
        
        let background = NSView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.wantsLayer = true
        background.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
        addSubview(background)
        
        let flip = Flip()
        flip.translatesAutoresizingMaskIntoConstraints = false
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.documentView = flip
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.drawsBackground = false
        scroll.scrollerInsets.bottom = 10
        scroll.automaticallyAdjustsContentInsets = false
        scroll.postsBoundsChangedNotifications = true
        addSubview(scroll)
        
        let stack = NSStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        flip.addSubview(stack)
        
        title.topAnchor.constraint(equalTo: topAnchor, constant: 35).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        url.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        url.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        url.widthAnchor.constraint(lessThanOrEqualToConstant: width - 20).isActive = true
        
        icon.topAnchor.constraint(equalTo: url.bottomAnchor, constant: 12).isActive = true
        icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 70).isActive = true
        
        description.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 5).isActive = true
        description.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
        
        background.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 30).isActive = true
        background.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        scroll.topAnchor.constraint(equalTo: background.topAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1).isActive = true
        
        flip.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        flip.leftAnchor.constraint(equalTo: scroll.leftAnchor).isActive = true
        flip.rightAnchor.constraint(equalTo: scroll.rightAnchor).isActive = true
        flip.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20).isActive = true
        
        stack.topAnchor.constraint(equalTo: flip.topAnchor, constant: 20).isActive = true
        stack.leftAnchor.constraint(equalTo: flip.leftAnchor, constant: 20).isActive = true
        stack.widthAnchor.constraint(equalToConstant: width - 40).isActive = true
        
        domain
            .sink {
                url.stringValue = $0
            }
            .store(in: &subs)
        
        domain
            .combineLatest(cloud
                .map(\.tracking)) {
                    $1.count(domain: $0)
                }
            .removeDuplicates()
            .sink {
                title.stringValue = $0.formatted()
            }
            .store(in: &subs)
        
        domain
            .combineLatest(cloud
                .map(\.tracking)) {
                    $1.items(for: $0)
                }
            .removeDuplicates()
            .sink {
                stack.setViews($0
                    .map { item in
                        let view = NSView()
                        view.wantsLayer = true
                        view.translatesAutoresizingMaskIntoConstraints = false
                        
                        let separator = CAShapeLayer()
                        separator.fillColor = .clear
                        separator.lineWidth = 1
                        separator.strokeColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
                        separator.path = .init(rect: .init(x: 0, y: 0, width: width - 40, height: 0), transform: nil)
                        view.layer!.addSublayer(separator)
                        
                        let text = Text(vibrancy: false)
                        text.stringValue = item.tracker
                        text.textColor = .secondaryLabelColor
                        text.font = .preferredFont(forTextStyle: .body)
                        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                        view.addSubview(text)
                        
                        let count = Text(vibrancy: false)
                        count.attributedStringValue = .make {
                            $0.append(.init(string: "×", attributes: [
                                .font : NSFont.monospacedDigitSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .medium),
                                .foregroundColor : NSColor.tertiaryLabelColor]))
                            $0.append(.init(string: item.count.formatted(), attributes: [
                                .font : NSFont.monospacedDigitSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .light),
                                .foregroundColor : NSColor.secondaryLabelColor]))
                        }
                        count.alignment = .right
                        view.addSubview(count)
                        
                        count.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
                        count.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
                        
                        text.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
                        text.rightAnchor.constraint(lessThanOrEqualTo: count.leftAnchor, constant: -10).isActive = true
                        text.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                        
                        view.bottomAnchor.constraint(equalTo: count.bottomAnchor, constant: 6).isActive = true
                        
                        return view
                    }, in: .center)
            }
            .store(in: &subs)
    }
    
    override var allowsVibrancy: Bool {
        true
    }
}
