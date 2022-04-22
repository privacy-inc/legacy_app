import AppKit
import Combine
import Specs

final class Landing: NSView, NSMenuDelegate {
    private weak var list: List!
    private weak var froob: NSView?
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
        empty.stringValue = "No bookmarks or history"
        addSubview(empty)
        
        let list = List(session: session, width: 426)
        self.list = list
        list.menu = .init()
        list.menu!.delegate = self
        
        (NSApp as! App)
            .froob
            .sink { [weak self] in
                if $0 && !Defaults.isPremium {
                    list.top.value = 200
                    
                    var froob = self?.froob
                    
                    if froob == nil {
                        froob = NSView()
                        froob!.wantsLayer = true
                        froob!.translatesAutoresizingMaskIntoConstraints = false
                        
                        let title = Text(vibrancy: true)
                        title.attributedStringValue = .make(alignment: .center) {
                            $0.append(.make("Support Privacy Browser", attributes: [
                                .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .medium),
                                .foregroundColor: NSColor.labelColor]))
                            $0.newLine()
                            $0.append(.make("Give your support to the independent team behind this browser.", attributes: [
                                .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular),
                                .foregroundColor: NSColor.secondaryLabelColor]))
                        }
                        froob!.addSubview(title)
                        
                        let control = Control.Prominent("Privacy Plus")
                        froob!.addSubview(control)
                        self?.add(control
                            .click
                            .sink {
                                NSApp.orderFrontStandardAboutPanel(nil)
                            })
                        
                        froob!.widthAnchor.constraint(equalToConstant: 300).isActive = true
                        froob!.heightAnchor.constraint(equalToConstant: 170).isActive = true
                        
                        title.topAnchor.constraint(equalTo: froob!.topAnchor).isActive = true
                        title.centerXAnchor.constraint(equalTo: froob!.centerXAnchor).isActive = true
                        title.widthAnchor.constraint(lessThanOrEqualToConstant: 260).isActive = true
                        
                        control.widthAnchor.constraint(equalToConstant: 260).isActive = true
                        control.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20).isActive = true
                        control.centerXAnchor.constraint(equalTo: froob!.centerXAnchor).isActive = true
                    }
                    
                    froob!.alphaValue = 0
                    list.documentView!.addSubview(froob!)
                    
                    froob!.topAnchor.constraint(equalTo: list.documentView!.topAnchor, constant: 30).isActive = true
                    froob!.centerXAnchor.constraint(equalTo: list.documentView!.centerXAnchor).isActive = true
                    
                    NSAnimationContext
                        .runAnimationGroup {
                            $0.allowsImplicitAnimation = true
                            $0.duration = 1
                            froob!.alphaValue = 1
                        }
                    
                } else {
                    list.top.value = 15
                    self?.froob?.removeFromSuperview()
                }
            }
            .store(in: &subs)
        
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
                view.frame.size = .init(width: 260, height: 180)
                
                let title = Text(vibrancy: false)
                title.font = .systemFont(ofSize: 45, weight: .thin)
                title.textColor = .labelColor
                view.addSubview(title)
                
                let icon = NSImageView(image: .init(systemSymbolName: "bolt.shield", accessibilityDescription: nil) ?? .init())
                icon.symbolConfiguration = .init(pointSize: 20, weight: .light)
                    .applying(.init(hierarchicalColor: .secondaryLabelColor))
                icon.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(icon)
                
                let description = Text(vibrancy: false)
                description.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular)
                description.textColor = .secondaryLabelColor
                description.stringValue = "Trackers prevented"
                view.addSubview(description)
                
                title.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
                title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                
                icon.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12).isActive = true
                icon.rightAnchor.constraint(equalTo: description.leftAnchor, constant: -4).isActive = true
                
                description.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
                description.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
                
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
    
    private func add(_ sub: AnyCancellable) {
        subs.insert(sub)
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
