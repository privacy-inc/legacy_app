/*import AppKit
import Combine

extension Landing {
    final class Activity: Simple {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(title: "Activity", icon: "chart.xyaxis.line")
            icon.symbolConfiguration = icon
                .symbolConfiguration!
                .applying(.init(paletteColors: [.labelColor, .init(named: "Dawn")!]))
            first.stringValue = "Since "
            first.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title2).pointSize, weight: .regular)
            
            card
                .click
                .sink {
                    NSApp.showActivity()
                }
                .store(in: &subs)
            
            cloud
                .map(\.events.since)
                .removeDuplicates()
                .sink { [weak self] in
                    self?.second.stringValue = ($0 ?? .now).formatted(.relative(presentation: .named, unitsStyle: .wide))
                }
                .store(in: &subs)
        }
    }
}
*/
