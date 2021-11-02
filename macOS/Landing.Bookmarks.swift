import AppKit
import Combine
import Specs

extension Landing {
    final class Bookmarks: Section {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(status: Status) {
            super.init()
            header.stringValue = "Bookmarks"
            
            let stack = NSStackView()
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.distribution = .fillEqually
            addSubview(stack)
            
            bottomAnchor.constraint(equalTo: stack.bottomAnchor).isActive = true
            
            stack.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10).isActive = true
            stack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            stack.heightAnchor.constraint(equalToConstant: 110).isActive = true
            
            cloud
                .map {
                    $0
                        .bookmarks
                        .prefix(4)
                }
                .removeDuplicates {
                    $0.map(\.access.value) == $1.map(\.access.value)
                }
                .sink { [weak self] bookmarks in
                    stack
                        .setViews(bookmarks
                                    .map { bookmark in
                            
                            
                            let item: Item
                            switch bookmark.access {
                            case let remote as Access.Remote:
                                item = Remote(title: bookmark.title, favicon: remote.domain.minimal)
                            default:
                                item = Other(title: bookmark.access.value)
                            }
                            
                            self?.listen(item: item, bookmark: bookmark, status: status)
                            
                            return item
                        },
                                  in: .center)
                }
                .store(in: &subs)
        }
        
        private func listen(item: Item, bookmark: Website, status: Status) {
            item
                .card
                .click
                .sink {
                    Task {
                        await status.access(access: bookmark.access)
                    }
                }
                .store(in: &subs)
        }
    }
}
