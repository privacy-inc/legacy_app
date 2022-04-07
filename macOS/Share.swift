import AppKit
import Combine
import UserNotifications

final class Share: NSPopover {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(web: Web, origin: NSView) {
        super.init()
        behavior = .semitransient
        contentSize = .zero
        contentViewController = .init()
        
        let view = NSView()
        contentViewController!.view = view
        
        let service = Option(title: "To service", symbol: "square.and.arrow.up")
        service
            .click
            .sink { [weak self] in
                self?.close()
                
                guard let url = web.url else { return }
                NSSharingServicePicker(items: [url])
                    .show(relativeTo: origin.bounds, of: origin, preferredEdge: .maxX)
            }
            .store(in: &subs)
        
        let save = Option(title: "Download", symbol: "square.and.arrow.down")
        save
            .click
            .sink { [weak self] in
                self?.close()
                web.saveAs()
            }
            .store(in: &subs)
        
        let copy = Option(title: "Copy Link", symbol: "link")
        copy
            .click
            .sink { [weak self] in
                self?.close()
                web.copyLink()
            }
            .store(in: &subs)
        
        let pdf = Option(title: "PDF", symbol: "doc.richtext")
        pdf
            .click
            .sink { [weak self] in
                self?.close()
                web.exportAsPdf()
            }
            .store(in: &subs)
        
        let snapshot = Option(title: "Snapshot", symbol: "text.below.photo.fill")
        snapshot
            .click
            .sink { [weak self] in
                self?.close()
                web.exportAsSnapshot()
            }
            .store(in: &subs)
        
        let archive = Option(title: "Webarchive", symbol: "doc.zipper")
        archive
            .click
            .sink { [weak self] in
                self?.close()
                web.exportAsWebarchive()
            }
            .store(in: &subs)
        
        let print = Option(title: "Print", symbol: "printer")
        print
            .click
            .sink { [weak self] in
                self?.close()
                web.printPage()
            }
            .store(in: &subs)
        
        let stack = NSStackView(views: [
            copy,
            service,
            save,
            pdf,
            snapshot,
            archive,
            print
        ])
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        view.addSubview(stack)

        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        stack.widthAnchor.constraint(equalToConstant: 190).isActive = true
    }
}
