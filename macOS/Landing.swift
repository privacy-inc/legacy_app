import AppKit
import Combine
import Specs

final class Landing: NSView, NSMenuDelegate {
    private weak var list: List!
    private var subs = Set<AnyCancellable>()
    private let session: Session

    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        self.session = session
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let empty = Text(vibrancy: true)
        empty.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular)
        empty.textColor = .tertiaryLabelColor
        empty.stringValue = "No history or bookmarks\nto show"
        addSubview(empty)
        
        let list = List(session: session, width: 426)
        self.list = list
        list.menu = .init()
        list.menu!.delegate = self
        addSubview(list)
        
        let configure = Control.Symbol("slider.vertical.3", point: 18, size: 40, weight: .light, hierarchical: true)
        configure
            .click
            .sink {
                (NSApp as! App).showPreferencesWindow(nil)
            }
            .store(in: &subs)
        
        let forget = Control.Symbol("flame", point: 18, size: 40, weight: .light, hierarchical: true)
        forget
            .click
            .sink {
                NSPopover().show(Forget(), from: forget, edge: .maxY)
            }
            .store(in: &subs)
        
        let trackers = Control.Symbol("bolt.shield", point: 21, size: 40, weight: .light, hierarchical: true)
        trackers
            .click
            .sink {
                let view = Vibrant(layer: false)
                view.translatesAutoresizingMaskIntoConstraints = true
                view.frame.size = .init(width: 200, height: 200)
                
                let title = Text(vibrancy: false)
                title.font = .systemFont(ofSize: 45, weight: .thin)
                title.textColor = .labelColor
                view.addSubview(title)
                
                let icon = NSImageView(image: .init(systemSymbolName: "bolt.shield", accessibilityDescription: nil) ?? .init())
                icon.symbolConfiguration = .init(pointSize: 26, weight: .light)
                    .applying(.init(hierarchicalColor: .secondaryLabelColor))
                icon.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(icon)
                
                let description = Text(vibrancy: false)
                description.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize, weight: .regular)
                description.textColor = .tertiaryLabelColor
                description.stringValue = "Trackers prevented"
                view.addSubview(description)
                
                title.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                
                icon.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12).isActive = true
                icon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                
                description.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                description.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 12).isActive = true
                
                NSPopover().show(view, from: trackers, edge: .maxY)
                
                Task {
                    title.stringValue = await cloud.model.tracking.total.formatted()
                }
            }
            .store(in: &subs)
        
        let stack = NSStackView(views: [trackers, forget, configure])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        addSubview(stack)
        
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        list.topAnchor.constraint(equalTo: topAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        list.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        list.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        empty.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        empty.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        list
            .empty
            .removeDuplicates()
            .sink {
                empty.isHidden = !$0
            }
            .store(in: &subs)
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        guard
            let id = list.highlighted.value,
            let url = URL(string: id)
        else {
            menu.items = []
            return
        }
        menu.items = [
            .child("Open", #selector(open)) {
                $0.target = self
                $0.image = .init(systemSymbolName: "return", accessibilityDescription: nil)
            },
            Menu.CopyLink(url: url, icon: true, shortcut: false),
            .separator(),
            Menu.Share(url: url, icon: true),
            .separator(),
            .child("Delete", #selector(delete)) {
                $0.target = self
                $0.image = .init(systemSymbolName: "trash", accessibilityDescription: nil)
            }]
    }
    
    override func mouseDown(with: NSEvent) {
        super.mouseDown(with: with)
        if with.clickCount == 1 {
            window?.makeFirstResponder(self)
        }
    }
    
    @objc private func open() {
        guard let url = list.highlighted.value else { return }
        Task {
            await session.open(url: URL(string: url)!, id: session.current.value)
        }
    }
    
    @objc private func delete() {
        guard let url = list.highlighted.value else { return }
        Task {
            await cloud.delete(url: url)
        }
    }
}
