import AppKit
import Combine
import UserNotifications
import StoreKit
import Specs

final class Detail: NSView {
    private weak var stack: NSStackView!
    private var subs = Set<AnyCancellable>()

    private var popover: NSPopover? {
        window?.value(forKey: "_popover") as? NSPopover
    }
    
    required init?(coder: NSCoder) { nil }
    init(session: Session, id: UUID) {
        super.init(frame: .init(origin: .zero, size: .init(width: 300, height: 200)))
        let icon = Icon(size: 50)
        
        let text = Text(vibrancy: true)
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let share = Control.Label(title: "Share", symbol: "square.and.arrow.up")
        
        let bookmark = Control.Label(title: "Bookmark", symbol: "bookmark")
        
        let pause = Control.Label(title: "Pause all media", symbol: "pause")
        
        let disable = Switch(title: "Disable text selection")
        
        let stack = Stack(views: [icon, text, share, bookmark, pause, disable])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        stack.spacing = 3
        stack.setCustomSpacing(20, after: icon)
        stack.setCustomSpacing(20, after: text)
        stack.setCustomSpacing(20, after: pause)
        addSubview(stack)
        self.stack = stack
        
        topAnchor.constraint(equalTo: topAnchor).isActive = true
        leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 32).isActive = true
        
        stack.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        stack.widthAnchor.constraint(equalTo: widthAnchor, constant: -60).isActive = true
        
        disable.leftAnchor.constraint(equalTo: stack.leftAnchor).isActive = true
        
        if case let .web(web) = session.flow(of: id) {
            icon.icon(website: web.url)
            
            web
                .publisher(for: \.url)
                .combineLatest(web
                    .publisher(for: \.title))
                .sink { url, title in
                    text.attributedStringValue = .make { string in
                        if let title = title,
                           !title.isEmpty {
                            string.append(.make(title.capped(max: 300) + " ", attributes: [
                                .font: NSFont.preferredFont(forTextStyle: .body),
                                .foregroundColor: NSColor.labelColor]))
                        }
                        
                        if let domain = url?.absoluteString.domain {
                            string.append(.make(domain, attributes: [
                                .font: NSFont.preferredFont(forTextStyle: .body),
                                .foregroundColor: NSColor.tertiaryLabelColor]))
                        }
                    }
                }
                .store(in: &subs)
            
            if let url = web.url {
                share.menu = .init()
                share.menu!.items = [
                    Menu.Link(url: url, icon: true, shortcut: false),
                    .separator(),
                    .child("Download...", #selector(web.saveAs)) {
                        $0.target = web
                        $0.image = .init(systemSymbolName: "square.and.arrow.down", accessibilityDescription: nil)
                    },
                    .child("Export as PDF...", #selector(web.exportAsPdf)) {
                        $0.target = web
                        $0.image = .init(systemSymbolName: "doc.richtext", accessibilityDescription: nil)
                    },
                    .child("Export as Snapshot...", #selector(web.exportAsSnapshot)) {
                        $0.target = web
                        $0.image = .init(systemSymbolName: "text.below.photo.fill", accessibilityDescription: nil)
                    },
                    .child("Export as Web archive...", #selector(web.exportAsWebarchive)) {
                        $0.target = web
                        $0.image = .init(systemSymbolName: "doc.zipper", accessibilityDescription: nil)
                    },
                    .child("Print...", #selector(web.printPage)) {
                        $0.target = web
                        $0.image = .init(systemSymbolName: "printer", accessibilityDescription: nil)
                    },
                    .separator(),
                    Menu.Share(title: "To Service...", url: url, icon: true)]
                
                share
                    .click
                    .sink {
                        share.menu?.popUp(positioning: nil, at: .init(x: 0, y: -8), in: share)
                    }
                    .store(in: &subs)
            }
            
            bookmark
                .click
                .sink { [weak self] in
                    self?.popover?.close()
                    
                    guard let url = web.url else { return }
                    
                    Task {
                        await cloud.bookmark(url: url, title: web.title ?? "")
                        await UNUserNotificationCenter.send(message: "Bookmark added!")
                        
                        if Defaults.rate {
                            SKStoreReviewController.requestReview()
                        }
                    }
                }
                .store(in: &subs)
            
            pause
                .click
                .sink { [weak self] in
                    self?.popover?.close()
                    
                    Task {
                        await MainActor
                            .run {
                                Task {
                                    await web.pauseAllMediaPlayback()
                                }
                            }
                    }
                }
                .store(in: &subs)
            
            disable.control.state = web.configuration.preferences.isTextInteractionEnabled ? .off : .on
            disable
                .change
                .sink {
                    web.configuration.preferences.isTextInteractionEnabled = !$0
                }
                .store(in: &subs)
        }
    }
}
