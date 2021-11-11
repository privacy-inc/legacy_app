import AppKit
import Combine

extension Landing {
    final class Trackers: Simple {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(title: "Trackers", icon: "shield.lefthalf.filled")
            first.font = .monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .title2).pointSize, weight: .regular)
            
            card
                .click
                .sink {
                    NSApp.showTrackers()
                }
                .store(in: &subs)
            
            cloud
                .map(\.events.prevented)
                .removeDuplicates()
                .sink { [weak self] in
                    self?.first.stringValue = $0.formatted()
                    self?.second.stringValue = $0 == 1 ? " Tracker prevented" : " Trackers prevented"
                }
                .store(in: &subs)
        }
    }
}
