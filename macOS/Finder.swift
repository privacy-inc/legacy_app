import AppKit

final class Finder: NSTitlebarAccessoryViewController {
    func reset() {
        view = .init()
        view.frame.size.height = 1
    }
}
