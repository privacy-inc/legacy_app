import AppKit
import Combine
import SwiftUI

private let width = CGFloat(340)

final class Trackers: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(domain: CurrentValueSubject<String, Never>) {
        super.init(frame: .init(origin: .zero, size: .init(width: width, height: 420)))
        
        let title = Text(vibrancy: false)
        title.font = .systemFont(ofSize: 65, weight: .thin)
        title.textColor = .labelColor
        addSubview(title)
        
        let url = Text(vibrancy: false)
        url.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular)
        url.textColor = .labelColor
        url.maximumNumberOfLines = 1
        url.lineBreakMode = .byTruncatingTail
        addSubview(url)
        
        let icon = NSImageView(image: .init(systemSymbolName: "bolt.shield", accessibilityDescription: nil) ?? .init())
        icon.symbolConfiguration = .init(pointSize: 30, weight: .light)
            .applying(.init(hierarchicalColor: .secondaryLabelColor))
        icon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(icon)
        
        let description = Text(vibrancy: false)
        description.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize)
        description.textColor = .secondaryLabelColor
        description.stringValue = "Trackers prevented\non this website"
        description.maximumNumberOfLines = 2
        addSubview(description)
        
        let separator = Separator()
        addSubview(separator)
        
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
        addSubview(scroll)
        
        let stack = NSStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        flip.addSubview(stack)
        
        title.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        url.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2).isActive = true
        url.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        url.widthAnchor.constraint(lessThanOrEqualToConstant: width - 40).isActive = true
        
        icon.centerYAnchor.constraint(equalTo: description.centerYAnchor).isActive = true
        icon.rightAnchor.constraint(equalTo: description.leftAnchor, constant: -2).isActive = true
        
        description.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 20).isActive = true
        description.topAnchor.constraint(equalTo: url.bottomAnchor, constant: 8).isActive = true
        
        separator.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 60).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        background.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
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
        flip.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30).isActive = true
        
        stack.topAnchor.constraint(equalTo: flip.topAnchor, constant: 10).isActive = true
        stack.leftAnchor.constraint(equalTo: flip.leftAnchor).isActive = true
        stack.widthAnchor.constraint(equalToConstant: width - 20).isActive = true
        
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
                    .enumerated()
                    .map { item in
                        let view = Vibrant(layer: false)
                        
                        let separator = Separator()
                        view.addSubview(separator)
                        
                        let index = Text(vibrancy: false)
                        index.stringValue = (item.0 + 1).formatted()
                        index.font = .monospacedDigitSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize, weight: .regular)
                        index.textColor = .secondaryLabelColor
                        index.alignment = .right
                        view.addSubview(index)
                                            
                        let text = Text(vibrancy: false)
                        text.stringValue = item.1.tracker
                        text.font = .preferredFont(forTextStyle: .body)
                        text.textColor = .labelColor
                        text.lineBreakMode = .byTruncatingTail
                        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                        view.addSubview(text)
                        
                        let count = Text(vibrancy: false)
                        count.attributedStringValue = .make {
                            $0.append(.make("×", attributes: [
                                .font : NSFont.monospacedDigitSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .medium),
                                .foregroundColor : NSColor.secondaryLabelColor]))
                            $0.append(.make(item.1.count.formatted(), attributes: [
                                .font : NSFont.monospacedDigitSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .light),
                                .foregroundColor : NSColor.labelColor]))
                        }
                        count.alignment = .right
                        view.addSubview(count)
                        
                        count.topAnchor.constraint(equalTo: view.topAnchor, constant: 13).isActive = true
                        count.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
                        
                        index.centerYAnchor.constraint(equalTo: count.centerYAnchor).isActive = true
                        index.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                        index.widthAnchor.constraint(equalToConstant: 35).isActive = true
                        
                        text.leftAnchor.constraint(equalTo: index.rightAnchor, constant: 2).isActive = true
                        text.rightAnchor.constraint(lessThanOrEqualTo: count.leftAnchor, constant: -10).isActive = true
                        text.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                        
                        separator.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
                        separator.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 35).isActive = true
                        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
                        separator.bottomAnchor.constraint(equalTo: count.bottomAnchor, constant: 10).isActive = true
                        
                        view.bottomAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
                        
                        return view
                    }, in: .center)
            }
            .store(in: &subs)
    }
    
    override var allowsVibrancy: Bool {
        true
    }
}
