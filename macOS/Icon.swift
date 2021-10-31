import AppKit
import Combine
import Specs

final class Icon: NSView {
    private weak var icon: NSImageView!
    private weak var backup: NSImageView!
    private var sub: AnyCancellable?
    
    required init?(coder: NSCoder) { nil }
    init(size: CGFloat = 32) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer = Layer()
        wantsLayer = true
        layer!.cornerRadius = 6
        layer!.cornerCurve = .continuous
        
        let backup = Image(icon: "network")
        backup.contentTintColor = .tertiaryLabelColor
        backup.symbolConfiguration = .init(textStyle: .largeTitle, scale: .large)
        self.backup = backup
        addSubview(backup)
        
        let icon = NSImageView()
        icon.imageScaling = .scaleProportionallyUpOrDown
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isHidden = true
        self.icon = icon
        addSubview(icon)
        
        widthAnchor.constraint(equalToConstant: size).isActive = true
        heightAnchor.constraint(equalToConstant: size).isActive = true
        
        icon.topAnchor.constraint(equalTo: topAnchor).isActive = true
        icon.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        icon.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        icon.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        backup.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backup.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backup.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        backup.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    override var allowsVibrancy: Bool {
        false
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
        self.icon.isHidden = true
        backup.isHidden = false
        sub?.cancel()
        guard
            let icon = icon,
            let publisher = await favicon.publisher(for: icon)
        else { return }
        sub = publisher
            .sink { [weak self] in
                self?.icon.image = $0
                self?.icon.isHidden = false
                self?.backup.isHidden = true
            }
    }
}
