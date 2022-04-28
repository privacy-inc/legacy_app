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
        addSubview(list)
        
        let vibrant = Vibrant(layer: false)
        addSubview(vibrant)
        
        let title = Text(vibrancy: true)
        title.font = .systemFont(ofSize: 40, weight: .thin)
        title.textColor = .labelColor
        addSubview(title)
        
        let icon = NSImageView(image: .init(systemSymbolName: "bolt.shield", accessibilityDescription: nil) ?? .init())
        icon.symbolConfiguration = .init(pointSize: 30, weight: .light)
            .applying(.init(hierarchicalColor: .secondaryLabelColor))
        icon.translatesAutoresizingMaskIntoConstraints = false
        vibrant.addSubview(icon)
        
        let description = Text(vibrancy: true)
        description.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize, weight: .regular)
        description.textColor = .secondaryLabelColor
        description.alignment = .right
        description.stringValue = "Trackers\nprevented"
        addSubview(description)
        
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
        
        let stack = NSStackView(views: [forget, configure])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        addSubview(stack)
        
        title.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        title.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        vibrant.topAnchor.constraint(equalTo: icon.topAnchor, constant: -5).isActive = true
        vibrant.bottomAnchor.constraint(equalTo: icon.bottomAnchor, constant: 5).isActive = true
        vibrant.leftAnchor.constraint(equalTo: icon.leftAnchor, constant: -5).isActive = true
        vibrant.rightAnchor.constraint(equalTo: icon.rightAnchor, constant: 5).isActive = true
        
        icon.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12).isActive = true
        icon.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        description.rightAnchor.constraint(equalTo: icon.leftAnchor, constant: -4).isActive = true
        description.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
        
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        list.topAnchor.constraint(equalTo: topAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        list.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        list.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        empty.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        let emptyTop = empty.topAnchor.constraint(equalTo: topAnchor)
        emptyTop.isActive = true
        
        list
            .empty
            .removeDuplicates()
            .sink {
                empty.isHidden = !$0
            }
            .store(in: &subs)
        
        cloud
            .map(\.tracking.total)
            .removeDuplicates()
            .sink {
                title.stringValue = $0.formatted()
            }
            .store(in: &subs)
        
        (NSApp as! App)
            .froob
            .sink { [weak self] in
                if $0 && !Defaults.isPremium {
                    list.top.value = 200
                    emptyTop.constant = 220
                    
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
                        self?.froob = froob
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
                    emptyTop.constant = 20
                    self?.froob?.removeFromSuperview()
                }
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
            .child("") { item in
                Task {
                    let count = await cloud.model.tracking.count(domain: url.absoluteString.domain)
                    item.attributedTitle = .make(count.formatted(), attributes: [
                        .font : NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .largeTitle).pointSize + 5, weight: .light)])
                }
            },
            .child("") {
                $0.attributedTitle = .make("Trackers prevented", attributes: [
                    .font : NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular)])
            },
            .separator(),
            .child("Open", #selector(open)) {
                $0.target = self
                $0.image = .init(systemSymbolName: "return", accessibilityDescription: nil)
            },
            Menu.Link(url: url, icon: true, shortcut: false),
            .separator(),
            Menu.Share(title: "Share", url: url, icon: true),
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
