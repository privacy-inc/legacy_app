import Foundation

struct CollectionItem<Info>: Hashable where Info : Identifiable & Hashable {
    let info: Info
    let rect: CGRect
}
