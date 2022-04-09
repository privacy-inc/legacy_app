import AppKit
import Combine
import Specs

final class Landing: NSView, NSMenuDelegate {
    private weak var list: List!
    private var subs = Set<AnyCancellable>()
    private let status: Status

    required init?(coder: NSCoder) { nil }
    init(status: Status) {
        self.status = status
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let empty = Text(vibrancy: true)
        empty.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular)
        empty.textColor = .tertiaryLabelColor
        empty.stringValue = "No history or bookmarks\nto show"
        addSubview(empty)
        
        let list = List(status: status, width: 426)
        self.list = list
        list.menu = .init()
        list.menu!.delegate = self
        addSubview(list)
        
        let configure = Control.Symbol("slider.vertical.3", point: 18, size: 40)
        configure
            .click
            .sink {
                (NSApp as! App).showPreferencesWindow(nil)
            }
            .store(in: &subs)
        
        let forget = Control.Symbol("flame", point: 18, size: 40)
        forget
            .click
            .sink {
                NSPopover().show(Forget(), from: forget, edge: .minY)
            }
            .store(in: &subs)
        
        let stack = NSStackView(views: [forget, configure])
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
            await status.open(url: URL(string: url)!, id: status.current.value)
        }
    }
    
    @objc private func delete() {
        guard let url = list.highlighted.value else { return }
        Task {
            await cloud.delete(url: url)
        }
    }
}
