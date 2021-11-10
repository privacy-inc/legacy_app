import AppKit
import Specs

extension Trackers {
    struct Info: CollectionItemInfo {
        let id: Int
        let text: NSAttributedString
        let count: NSAttributedString
        let trackers: [String]
        let icon: String
        
        init(id: Int, report: Events.Report) {
            self.id = id
            self.text = .init(
                .init(report.website, attributes: .init([
                    .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular),
                    .foregroundColor: NSColor.labelColor]))
                + .newLine
                + .init(report.date.formatted(.relative(presentation: .named, unitsStyle: .wide)), attributes: .init([
                    .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize, weight: .regular),
                    .foregroundColor: NSColor.secondaryLabelColor])))
            self.count = .init()
            self.trackers = []
            self.icon = report.website.lowercased()
        }
    }
}
