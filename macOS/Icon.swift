import AppKit
import Combine
import Specs

final class Icon: NSView {
    private weak var icon: NSImageView!
    private weak var width: NSLayoutConstraint!
    private var sub: AnyCancellable?
    private let size: CGFloat
    
    required init?(coder: NSCoder) { nil }
    init(size: CGFloat = 32) {
        self.size = size
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let icon = NSImageView()
        icon.wantsLayer = true
        icon.layer!.cornerRadius = 6
        icon.layer!.cornerCurve = .continuous
        icon.imageScaling = .scaleProportionallyUpOrDown
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isHidden = true
        self.icon = icon
        addSubview(icon)
        
        heightAnchor.constraint(equalToConstant: size).isActive = true
        width = widthAnchor.constraint(equalToConstant: 0)
        width.isActive = true
        
        icon.topAnchor.constraint(equalTo: topAnchor).isActive = true
        icon.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        icon.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        icon.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    override func hitTest(_: NSPoint) -> NSView? {
        nil
    }
    
    func icon(website: String?) {
        Task
            .detached { [weak self] in
                await self?.update(website: website)
            }
    }
    
    @MainActor private func update(website: String?) async {
        width.constant = 0
        icon.isHidden = true
        sub?.cancel()
        guard
            let website = website,
            let publisher = await favicon.publisher(for: website)
        else { return }
        sub = publisher
            .sink { [weak self, size] in
                self?.width.constant = size
                self?.icon.image = $0
                self?.icon.isHidden = false
            }
    }
}
