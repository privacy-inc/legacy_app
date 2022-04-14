import AppKit
import Combine
import UserNotifications

final class Detail: NSScrollView {
    private weak var stack: NSStackView!
    private var subs = Set<AnyCancellable>()

    private var popover: NSPopover? {
        window?.value(forKey: "_popover") as? NSPopover
    }
    
    required init?(coder: NSCoder) { nil }
    init(session: Session, id: UUID) {
        super.init(frame: .init(origin: .zero, size: .init(width: 320, height: 360)))
        hasVerticalScroller = true
        verticalScroller!.controlSize = .mini
        drawsBackground = false
        scrollerInsets.top = 10
        scrollerInsets.bottom = 10
        automaticallyAdjustsContentInsets = false
        
        let flip = Flip()
        flip.translatesAutoresizingMaskIntoConstraints = false
        documentView = flip
        
        let icon = Icon(size: 48)
        
        let text = Text(vibrancy: true)
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let share = Control.Label(title: "Share", symbol: "square.and.arrow.up")
        
        let bookmark = Control.Label(title: "Bookmark", symbol: "bookmark")
        
        let pause = Control.Label(title: "Pause all media", symbol: "pause")
        
        let disable = Switch(title: "Disable text selection")
        
        let stack = NSStackView(views: [icon, text, share, bookmark, pause, disable])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        stack.spacing = 3
        stack.setCustomSpacing(20, after: icon)
        stack.setCustomSpacing(20, after: text)
        stack.setCustomSpacing(20, after: pause)
        flip.addSubview(stack)
        self.stack = stack
        
        flip.topAnchor.constraint(equalTo: topAnchor).isActive = true
        flip.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        flip.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        flip.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30).isActive = true
        
        stack.topAnchor.constraint(equalTo: flip.topAnchor, constant: 30).isActive = true
        stack.leftAnchor.constraint(equalTo: flip.leftAnchor, constant: 30).isActive = true
        stack.widthAnchor.constraint(equalTo: widthAnchor, constant: -60).isActive = true
        
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
                            string.append(.make(title + " ", attributes: [
                                .font: NSFont.preferredFont(forTextStyle: .callout),
                                .foregroundColor: NSColor.labelColor]))
                        }
                        
                        if let domain = url?.absoluteString.domain {
                            string.append(.make(domain, attributes: [
                                .font: NSFont.preferredFont(forTextStyle: .callout),
                                .foregroundColor: NSColor.tertiaryLabelColor]))
                        }
                    }
                }
                .store(in: &subs)
            
            share
                .click
                .sink { [weak self] in
                    self?.share(web: web)
                }
                .store(in: &subs)
            
            bookmark
                .click
                .sink { [weak self] in
                    self?.popover?.close()
                    
                    guard let url = web.url else { return }
                    
                    Task {
                        await cloud.bookmark(url: url, title: web.title ?? "")
                        await UNUserNotificationCenter.send(message: "Bookmark added!")
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
    
    private func share(web: Web) {
        let title = Text(vibrancy: true)
        title.stringValue = "Share"
        title.font = .preferredFont(forTextStyle: .body)
        title.textColor = .labelColor

        let save = Control.Label(title: "Download", symbol: "square.and.arrow.down")
        save
            .click
            .sink { [weak self] in
                self?.popover?.close()
                web.saveAs()
            }
            .store(in: &subs)
        
        let pdf = Control.Label(title: "PDF", symbol: "doc.richtext")
        pdf
            .click
            .sink { [weak self] in
                self?.popover?.close()
                web.exportAsPdf()
            }
            .store(in: &subs)
        
        let snapshot = Control.Label(title: "Snapshot", symbol: "text.below.photo.fill")
        snapshot
            .click
            .sink { [weak self] in
                self?.popover?.close()
                web.exportAsSnapshot()
            }
            .store(in: &subs)
        
        let archive = Control.Label(title: "Webarchive", symbol: "doc.zipper")
        archive
            .click
            .sink { [weak self] in
                self?.popover?.close()
                web.exportAsWebarchive()
            }
            .store(in: &subs)
        
        let print = Control.Label(title: "Print", symbol: "printer")
        print
            .click
            .sink { [weak self] in
                self?.popover?.close()
                web.printPage()
            }
            .store(in: &subs)
        
        stack.setViews([title, save, pdf, snapshot, archive, print], in: .top)
        stack.setCustomSpacing(20, after: title)
        
        NSAnimationContext
            .runAnimationGroup {
                $0.allowsImplicitAnimation = true
                $0.duration = 0.3
                stack.layoutSubtreeIfNeeded()
                popover?.contentSize = .init(width: 240, height: 275)
            }
    }
}
