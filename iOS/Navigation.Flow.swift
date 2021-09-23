import Foundation

extension Navigation {
    enum Flow {
        case
        menu,
        landing(Int),
        tab(Int),
        tabs(Int),
        search(Int)
    }
}
