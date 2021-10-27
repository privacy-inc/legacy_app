import Foundation

struct CollectionItem<Info>: Hashable where Info : CollectionItemInfo {
    let info: Info
    let rect: CGRect
}
