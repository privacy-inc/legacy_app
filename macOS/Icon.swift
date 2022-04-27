import AppKit
import Combine
import Specs

final class Icon: NSView {
    let image = CurrentValueSubject<NSImage?, Never>(nil)
    private weak var width: NSLayoutConstraint!
    private var sub1: AnyCancellable?
    private var sub2: AnyCancellable?
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
        addSubview(image)
        
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        width = widthAnchor.constraint(equalToConstant: 0)
        width.isActive = true
        
        image.topAnchor.constraint(equalTo: topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        sub2 = self.image
            .sink {
                image.image = $0
            }
    }
    
    override func hitTest(_: NSPoint) -> NSView? {
        nil
    }
    
    func icon(website: URL?) {
        image.value = nil
        width.constant = 0
        sub1?.cancel()
        
        Task
            .detached { [weak self] in
                await self?.update(website: website)
            }
    }
    
    @MainActor private func update(website: URL?) async {
        guard
            let website = website,
            let publisher = await favicon.publisher(for: website)
        else { return }
        sub1 = publisher
            .sink { [weak self, size] in
                self?.width.constant = size
                self?.image.value = $0
            }
    }
}
