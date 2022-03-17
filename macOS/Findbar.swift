import AppKit

final class Findbar: NSTitlebarAccessoryViewController {
    func reset() {
        view = .init()
        view.frame.size.height = 1
    }
}
