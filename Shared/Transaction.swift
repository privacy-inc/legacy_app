import StoreKit

extension Transaction {
    func process() async {
        guard let item = Store.Item(rawValue: productID) else { return }
        await item.purchased(active: revocationDate == nil)
        await finish()
    }
}
