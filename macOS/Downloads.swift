import AppKit

final class Downloads: NSVisualEffectView {
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        super.init(frame: .zero)
        state = .active
        material = .menu
    }
}
