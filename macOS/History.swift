import AppKit
import Combine

final class History: Websites {
    override init() {
        super.init()
        setFrameAutosaveName("History")
        navigation.stringValue = "History"
        
        cloud
            .map(\.history)
            .map {
                $0
                    .enumerated()
                    .map {
                        .init(id: $0.0, history: $0.1)
                    }
            }
            .sink { [weak self] in
                self?.list.info.send($0)
            }
            .store(in: &subs)
    }
}
