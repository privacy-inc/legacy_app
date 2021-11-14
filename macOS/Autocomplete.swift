import AppKit
import Combine

final class Autocomplete: NSPanel {
    let adjust = PassthroughSubject<(position: CGPoint, width: CGFloat), Never>()
    private(set) weak var list: List!
    private var monitor: Any?
    private var subs = Set<AnyCancellable>()
    
    init(status: Status) {
        super.init(contentRect: .zero,
                   styleMask: [.borderless],
                   backing: .buffered,
                   defer: true)
        isOpaque = false
        backgroundColor = .clear
        hasShadow = true
        
        let blur = NSVisualEffectView()
        blur.material = .hudWindow
        blur.state = .active
        blur.wantsLayer = true
        blur.layer!.cornerRadius = 12
        contentView!.addSubview(blur)
        
        let list = List(status: status)
        self.list = list
        blur.addSubview(list)
        
        list.topAnchor.constraint(equalTo: blur.topAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo: blur.bottomAnchor).isActive = true
        list.leftAnchor.constraint(equalTo: blur.leftAnchor).isActive = true
        list.rightAnchor.constraint(equalTo: blur.rightAnchor).isActive = true
        
        adjust
            .combineLatest(list
                            .size
                            .map(\.height)
                            .map {
                                min($0, 300)
                            }
                            .removeDuplicates())
            .sink { [weak self] in
                blur.frame.size = .init(width: $0.0.width, height: $0.1)
                self?.setContentSize(blur.frame.size)
                self?.setFrameTopLeftPoint($0.0.position)
            }
            .store(in: &subs)
    }
    
    func start() {
        guard monitor == nil else { return }
        monitor = NSEvent
            .addLocalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown, .otherMouseDown]) { [weak self] event in
                if self?.isVisible == true && event.window != self {
                    self?.close()
                }
                return event
            }
    }
    
    override func close() {
        monitor
            .map(NSEvent.removeMonitor)
        monitor = nil
        parent?.removeChildWindow(self)
        super.close()
    }
    
    func find(string: String) {
        Task {
            await list.found.send(cloud.autocomplete(search: string))
        }
    }
}
