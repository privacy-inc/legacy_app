import AppKit

final class Findbar: NSTitlebarAccessoryViewController {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(nibName: nil, bundle: nil)
        reset()
        layoutAttribute = .bottom
    }
    
    func reset() {
        view = .init()
        view.frame.size.height = 1
    }
}
