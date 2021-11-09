import Foundation
import Specs

extension Trackers {
    struct Info: CollectionItemInfo {
        let id: Int
        let first: Bool
        let date: NSAttributedString
        let website: NSAttributedString
        let count: NSAttributedString
        let trackers: [String]
        let icon: String
        
        init(id: Int, first: Bool, report: Events.Report) {
            self.id = id
            self.first = first
            self.date = .init()
            self.website = .init()
            self.count = .init()
            self.trackers = []
            self.icon = ""
        }
    }
}
