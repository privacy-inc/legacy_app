import WebKit
import Combine
import StoreKit
import Specs

final class Downloads: NSVisualEffectView {
    private weak var stack: NSStackView!
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        state = .active
        material = .menu
        
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        self.stack = stack
        
        let done = Control.Title("Clear", color: .labelColor, layer: true)
        done
            .click
            .sink { [weak self] in
                stack.animator().setViews([], in: .center)
                self?.animator().frame.size.height = 1
                try? FileManager.default.removeItem(at: .init(fileURLWithPath: NSTemporaryDirectory()))
            }
            .store(in: &subs)
        addSubview(done)
        
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        done.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        done.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
    }
    
    func add(download: WKDownload) {
        guard !stack.views.map({ ($0 as! Item).download }).contains(download) else { return }
        stack.animator().addView(Item(download: download), in: .center)
        resize()
    }
    
    func remove(item: Item) {
        stack.animator().removeView(item)
        resize()
    }
    
    func failed(download: WKDownload, data: Data?) {
        stack
            .views
            .map {
                $0 as! Item
            }
            .first {
                $0.download == download
            }
            .map {
                $0.cancel(data: data)
            }
    }
    
    private func resize() {
        animator().frame.size.height = .init(stack.views.count) * 40 + 60
    }
}
