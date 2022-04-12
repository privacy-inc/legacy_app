import AppKit
import Combine

private let width = CGFloat(300)

final class Detail: NSScrollView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(status: Status, id: UUID) {
        super.init(frame: .init(origin: .zero, size: .init(width: width, height: 360)))
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
        
        let share = Control.Label(title: "Share", symbol: "square.and.arrow.up")
        
        let service = Control.Label(title: "To service", symbol: "square.and.arrow.up")
        service
            .click
            .sink { [weak self] in
//                self?.close()
//
//                guard let url = web.url else { return }
//                NSSharingServicePicker(items: [url])
//                    .show(relativeTo: origin.bounds, of: origin, preferredEdge: .maxX)
            }
            .store(in: &subs)
        
        let save = Control.Label(title: "Download", symbol: "square.and.arrow.down")
        save
            .click
            .sink { [weak self] in
//                self?.close()
//                web.saveAs()
            }
            .store(in: &subs)
        
        let copy = Control.Label(title: "Copy Link", symbol: "link")
        copy
            .click
            .sink { [weak self] in
//                self?.close()
////                web.copyLink()
            }
            .store(in: &subs)
        
        let pdf = Control.Label(title: "PDF", symbol: "doc.richtext")
        pdf
            .click
            .sink { [weak self] in
//                self?.close()
//                web.exportAsPdf()
            }
            .store(in: &subs)
        
        let snapshot = Control.Label(title: "Snapshot", symbol: "text.below.photo.fill")
        snapshot
            .click
            .sink { [weak self] in
//                self?.close()
//                web.exportAsSnapshot()
            }
            .store(in: &subs)
        
        let archive = Control.Label(title: "Webarchive", symbol: "doc.zipper")
        archive
            .click
            .sink { [weak self] in
//                self?.close()
//                web.exportAsWebarchive()
            }
            .store(in: &subs)
        
        let print = Control.Label(title: "Print", symbol: "printer")
        print
            .click
            .sink { [weak self] in
//                self?.close()
//                web.printPage()
            }
            .store(in: &subs)
        
        let bookmark = Control.Label(title: "Bookmark", symbol: "bookmark")
        
        let pause = Control.Label(title: "Pause all media", symbol: "pause.circle.fill")
        
        let disable = Switch(title: "Disable text selection")
        
        let shares = [service, save, copy, pdf, snapshot, archive, print]
        let others = [bookmark, pause]
        shares
            .forEach {
                $0.state = .hidden
            }
        
        let stack = NSStackView(views: [icon, text, share] + shares + others + [disable])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        stack.spacing = 3
        stack.setCustomSpacing(20, after: icon)
        stack.setCustomSpacing(20, after: text)
        stack.setCustomSpacing(20, after: pause)
        flip.addSubview(stack)
        
        share
            .click
            .sink { [weak self] in
                if share.state == .selected {
                    share.state = .on
                    shares
                        .forEach {
                            $0.state = .hidden
                        }
                    others
                        .forEach {
                            $0.state = .on
                        }
                    disable.isHidden = false
                } else {
                    share.state = .selected
                    shares
                        .forEach {
                            $0.state = .on
                        }
                    others
                        .forEach {
                            $0.state = .hidden
                        }
                    disable.isHidden = true
                }
                
                NSAnimationContext
                    .runAnimationGroup {
                        $0.allowsImplicitAnimation = true
                        $0.duration = 0.3
                        stack.layoutSubtreeIfNeeded()
                    }
            }
            .store(in: &subs)
        
        flip.topAnchor.constraint(equalTo: topAnchor).isActive = true
        flip.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        flip.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        flip.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30).isActive = true
        
        stack.topAnchor.constraint(equalTo: flip.topAnchor, constant: 30).isActive = true
        stack.leftAnchor.constraint(equalTo: flip.leftAnchor, constant: 30).isActive = true
        stack.widthAnchor.constraint(equalToConstant: width - 60).isActive = true
        
        if case let .web(web) = status.flow(of: id) {
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
            
            bookmark
                .click
                .sink { [weak self] in
//                    self?.close()
                    
//                    Task
//                        .detached {
//                            await UNUserNotificationCenter.send(message: "Bookmark added!")
//    #warning("bookmark")
//                            //                        await cloud.bookmark(history: web.history)
//                        }
                }
                .store(in: &subs)
            
            pause
                .click
                .sink { [weak self] in
//                    self?.close()
//                    
//                    Task {
//                        await MainActor
//                            .run {
//                                Task {
//                                    await web.pauseAllMediaPlayback()
//                                }
//                            }
//                    }
                }
                .store(in: &subs)
            
            disable.control.state = web.configuration.preferences.isTextInteractionEnabled ? .off : .on
            disable
                .change
                .sink { [weak web] in
                    web?.configuration.preferences.isTextInteractionEnabled = !$0
                }
                .store(in: &subs)
        }
        
        
        //web?.configuration.preferences.isTextInteractionEnabled
        
        
//        super.init()
//        behavior = .transient
//        contentSize = .zero
//        contentViewController = .init()
//        
//        let view = NSView()
//        contentViewController!.view = view
//        

//        
//
//        
//        let stack = NSStackView(views: [
//            header(web: web),
//            disable,
//            share,
//            bookmark,
//            pause
//        ])
//        stack.spacing = 6
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.orientation = .vertical
//        view.addSubview(stack)
//
//        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
//        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
//        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
//        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
//        stack.widthAnchor.constraint(equalToConstant: 240).isActive = true
    }
}
