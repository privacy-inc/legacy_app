import Foundation
import Specs

extension Trackers {
    struct Info: CollectionItemInfo {
        let id: Int
        let first: Bool
        let date: NSAttributedString
        let website: NSAttributedString
        let count: NSAttributedString
        let trackers: [NSAttributedString]
        let icon: String
        let height: CGFloat
        
        init(id: Int, report: Events.Report) {
            
        }
    }
}
