import AppKit
import Combine
import Specs

extension Landing {
    final class Bookmarks: Section {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
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
                .sink { bookmarks in
                    stack
                        .setViews(bookmarks
                                    .map { bookmark in
                            switch bookmark.access {
                            case is Access.Remote:
                                return Remote(bookmark: bookmark)
                            default:
                                return Other(title: bookmark.access.value)
                            }
                        },
                                  in: .center)
                }
                .store(in: &subs)
        }
    }
}
