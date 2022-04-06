import AppKit

final class Downloads: NSVisualEffectView {
    required init?(coder: NSCoder) { nil }
    init(status: Status) {
        super.init(frame: .zero)
        state = .active
        material = .menu
    }
}
