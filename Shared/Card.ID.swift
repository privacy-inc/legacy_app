import Foundation
import Specs

extension Specs.Card.ID {
    var title: String {
        "\(self)".capitalized
    }
    
    var symbol: String {
        switch self {
        case .trackers:
            return "shield.lefthalf.filled"
        case .activity:
            return "chart.xyaxis.line"
        case .bookmarks:
            return "bookmark"
        case .history:
            return "clock"
        }
    }
}
