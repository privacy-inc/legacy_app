import Foundation
import Specs

final class Session: ObservableObject {
    @Published private(set) var status = Status.tabs
    @Published var froob = false
    var dark = false
}
