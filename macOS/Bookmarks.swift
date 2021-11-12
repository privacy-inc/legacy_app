import AppKit
import Combine

final class Bookmarks: Websites {
    override init() {
        super.init()
        setFrameAutosaveName("Bookmarks")
        navigation.stringValue = "Bookmarks"
        icon.image = .init(systemSymbolName: "bookmark", accessibilityDescription: nil)
        
        cloud
            .first()
            .merge(with: cloud
                    .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main))
            .map(\.bookmarks)
            .map {
                $0
                    .enumerated()
                    .map {
                        .init(id: $0.0, bookmark: $0.1)
                    }
            }
            .removeDuplicates()
            .sink { [weak self] in
                self?.list.info.send($0)
            }
            .store(in: &subs)
        
        list
            .open
            .sink { index in
                Task {
                    await NSApp.open(access: cloud.model.bookmarks[index].access)
                }
            }
            .store(in: &subs)
        
        list
            .delete
            .sink { index in
                Task
                    .detached(priority: .utility) {
                        await cloud.delete(bookmark: index)
                    }
            }
            .store(in: &subs)
    }
}
