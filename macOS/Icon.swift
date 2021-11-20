import AppKit
import Combine
import Specs

final class Icon: NSView {
    private weak var icon: NSImageView!
    private weak var backup: Vibrant!
    private var sub: AnyCancellable?
    
    required init?(coder: NSCoder) { nil }
    init(size: CGFloat = 32) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let backup = Vibrant(layer: false)
        backup.translatesAutoresizingMaskIntoConstraints = false
        self.backup = backup
        addSubview(backup)
        
        let network = Image(icon: "network")
        network.symbolConfiguration = .init(pointSize: 40, weight: .thin)
            .applying(.init(hierarchicalColor: .tertiaryLabelColor))
        backup.addSubview(network)
        
        let icon = NSImageView()
        icon.wantsLayer = true
        icon.layer!.cornerRadius = 6
        icon.layer!.cornerCurve = .continuous
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
        
        network.topAnchor.constraint(equalTo: backup.topAnchor).isActive = true
        network.bottomAnchor.constraint(equalTo: backup.bottomAnchor).isActive = true
        network.leftAnchor.constraint(equalTo: backup.leftAnchor).isActive = true
        network.rightAnchor.constraint(equalTo: backup.rightAnchor).isActive = true
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
