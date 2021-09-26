import StoreKit

extension Store {
    enum Status {
        case
        loading,
        error(String),
        products([Product])
    }
}
