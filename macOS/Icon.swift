import AppKit
import Combine
import Specs

final class Icon: NSImageView {
    private var sub: AnyCancellable?
    private var empty: NSImage? {
        .init(systemSymbolName: "network", accessibilityDescription: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    init(size: CGFloat = 32) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        image = empty
        symbolConfiguration = .init(textStyle: .largeTitle, scale: .large)
            .applying(.init(hierarchicalColor: .tertiaryLabelColor))
        
        widthAnchor.constraint(equalToConstant: size).isActive = true
        heightAnchor.constraint(equalToConstant: size).isActive = true
    }
    
    override func hitTest(_: NSPoint) -> NSView? {
        nil
    }
    
    func icon(icon: String?) {
        Task
            .detached { [weak self] in
                await self?.update(icon: icon)
            }
    }
    
    @MainActor private func update(icon: String?) async {
        image = empty
        sub?.cancel()
        guard
            let icon = icon,
            let publisher = await favicon.publisher(for: icon)
        else { return }
        sub = publisher
            .sink { [weak self] in
                self?.image = $0
            }
    }
}
