import AppKit
import Specs

extension History {
    struct Info: CollectionItemInfo {
        let id: Int
        let text: NSAttributedString
        let count: NSAttributedString
        let trackers: [String]
        let icon: String
        
        init(id: Int, report: Events.Report) {
            self.id = id
            text = .init(
                .init(report.website, attributes: .init([
                    .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular),
                    .foregroundColor: NSColor.labelColor]))
                + .newLine
                + .init(report.date.formatted(.relative(presentation: .named, unitsStyle: .wide)), attributes: .init([
                    .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize, weight: .regular),
                    .foregroundColor: NSColor.secondaryLabelColor])))
            count = .init(
                .init(report.trackers.count.formatted(), attributes: .init([
                    .font: NSFont.monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular),
                    .foregroundColor: NSColor.labelColor]))
                + .init(report.trackers.count == 1 ? " tracker" : " trackers", attributes: .init([
                    .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular),
                    .foregroundColor: NSColor.secondaryLabelColor])))
            trackers = report.trackers.sorted()
            icon = report.website.lowercased()
        }
    }
}
