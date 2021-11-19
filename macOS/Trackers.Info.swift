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
            text = .make {
                $0.append(.make(report.website, attributes: [
                        .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular),
                        .foregroundColor: NSColor.labelColor]))
                $0.newLine()
                $0.append(.make(report.date.formatted(.relative(presentation: .named, unitsStyle: .wide)), attributes: [
                        .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize, weight: .regular),
                        .foregroundColor: NSColor.secondaryLabelColor]))
            }
            count = .make {
                $0.append(.make(report.trackers.count.formatted(), attributes: [
                        .font: NSFont.monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular),
                        .foregroundColor: NSColor.labelColor]))
                $0.append(.make(report.trackers.count == 1 ? " tracker" : " trackers", attributes: [
                        .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular),
                        .foregroundColor: NSColor.secondaryLabelColor]))
            }
            trackers = report.trackers.sorted()
            icon = report.website.lowercased()
        }
    }
}
