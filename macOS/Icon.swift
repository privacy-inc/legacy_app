import AppKit
import Combine
import Specs

final class Icon: NSView {
    private(set) weak var image: NSImageView!
    private weak var width: NSLayoutConstraint!
    private var sub: AnyCancellable?
    private let size: CGFloat
    
    required init?(coder: NSCoder) { nil }
    init(size: CGFloat = 24) {
        self.size = size
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let image = NSImageView()
        image.wantsLayer = true
        image.layer!.cornerRadius = 6
        image.layer!.cornerCurve = .continuous
        image.imageScaling = .scaleProportionallyUpOrDown
        image.translatesAutoresizingMaskIntoConstraints = false
        self.image = image
        addSubview(image)
        
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        width = widthAnchor.constraint(equalToConstant: 0)
        width.isActive = true
        
        image.topAnchor.constraint(equalTo: topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    override func hitTest(_: NSPoint) -> NSView? {
        nil
    }
    
    func icon(website: URL?) {
        Task
            .detached { [weak self] in
                await self?.update(website: website)
            }
    }
    
    @MainActor private func update(website: URL?) async {
        width.constant = 0
        sub?.cancel()
        guard
            let website = website,
            let publisher = await favicon.publisher(for: website)
        else { return }
        sub = publisher
            .sink { [weak self, size] in
                self?.width.constant = size
                self?.image.image = $0
            }
    }
}
