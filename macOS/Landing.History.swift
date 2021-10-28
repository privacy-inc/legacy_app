import AppKit
import Combine
import Specs

extension Landing {
    final class History: Section {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            header.stringValue = "History"
            
            bottomAnchor.constraint(greaterThanOrEqualTo: header.bottomAnchor, constant: 10).isActive = true
            
            cloud
                .map {
                    $0
                        .history
                        .suffix(10)
                }
                .removeDuplicates {
                    $0.map(\.website.access.value) == $1.map(\.website.access.value)
                }
                .sink { history in
//                    stack
//                        .setViews(bookmarks
//                                    .map { bookmark in
//                            switch bookmark.access {
//                            case is Access.Remote:
//                                return Remote(bookmark: bookmark)
//                            default:
//                                return Other(title: bookmark.access.value)
//                            }
//                        },
//                                  in: .center)
                }
                .store(in: &subs)
        }
    }
}
