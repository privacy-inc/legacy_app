import AppKit
import Combine

final class Subbar: NSVisualEffectView {
    private weak var stop: Window.Option!
    private weak var reload: Window.Option!
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(status: Status) {
        super.init(frame: .zero)
        state = .active
        material = .menu
        
        let secure = Window.Option(icon: "lock.fill", size: 11, color: .tertiaryLabelColor)
        secure.toolTip = "Secure connection"
        secure.state = .hidden
        
        let insercure = Window.Option(icon: "exclamationmark.triangle.fill", size: 12, color: .tertiaryLabelColor)
        insercure.toolTip = "Insecure"
        insercure.state = .hidden
        
        let options = Window.Option(icon: "ellipsis.circle.fill", size: 14)
        options.toolTip = "Options"
        options.state = .hidden
        
        let back = Window.Option(icon: "chevron.backward", size: 13)
        back.toolTip = "Back"
        back.state = .hidden
        
        let forward = Window.Option(icon: "chevron.forward", size: 13)
        forward.toolTip = "Forward"
        forward.state = .hidden
        
        let reload = Window.Option(icon: "arrow.clockwise", size: 11)
        reload.toolTip = "Reload"
        reload.state = .hidden
        self.reload = reload
        
        let stop = Window.Option(icon: "xmark", size: 11)
        stop.toolTip = "Stop"
        stop.state = .hidden
        self.stop = stop
        
        let stack = NSStackView(views: [secure, insercure, back, forward, reload, stop, options])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 0
        addSubview(stack)
        
        stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        status
            .current
            .combineLatest(status.items) { current, items in
                items
                    .first {
                        $0.id == current
                    }
            }
            .compactMap {
                switch $0?.flow {
                case let .web(web), let .error(web, _):
                    return web
                default:
                    return nil
                }
            }
            .first()
            .sink { [weak self] (web: Web) in
                self?.listen(web: web)
            }
            .store(in: &subs)
    }
    
    private func listen(web: Web) {
        web
            .publisher(for: \.isLoading)
            .removeDuplicates()
            .sink { [weak self] in
                self?.stop.state = $0 ? .on : .hidden
                self?.reload.state = $0 ? .hidden : .on
            }
            .store(in: &subs)
    }
}
