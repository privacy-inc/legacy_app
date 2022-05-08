import StoreKit

extension Store {
    enum Status: Equatable {
        case
        loading,
        error(String),
        products([Product])
    }
}
