import Foundation

protocol CollectionItemInfo: Hashable {
    associatedtype ID : Equatable
    
    var id: ID { get }
}
