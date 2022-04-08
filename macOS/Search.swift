import AppKit
import Combine

final class Search: NSTextField {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        Self.cellClass = Cell.self
        super.init(frame: .zero)
        bezelStyle = .roundedBezel
        translatesAutoresizingMaskIntoConstraints = false
        font = .preferredFont(forTextStyle: .body)
        controlSize = .large
        lineBreakMode = .byTruncatingTail
        textColor = .labelColor
        isAutomaticTextCompletionEnabled = false
    }
    
    func listen(web: Web, status: Status, id: UUID) {
        web
            .publisher(for: \.url)
            .compactMap {
                $0
            }
            .removeDuplicates()
            .combineLatest(status
                            .items
                            .compactMap {
                                $0
                                    .first {
                                        $0.id == id
                                    }?
                                    .flow
                            }
                            .removeDuplicates())
            .sink { [weak self] url, flow in
                switch flow {
                case .web:
                    var string = url
                        .absoluteString
                        .replacingOccurrences(of: "https://", with: "")
                    
                    if string.last == "/" {
                        string.removeLast()
                    }
                    
                    self?.stringValue = string
                    
                case let .message(_, url, title, _):
                    self?.stringValue = url?.absoluteString ?? title
                default:
                    break
                }
                
                self?.undoManager?.removeAllActions()
            }
            .store(in: &subs)
    }
    
    deinit {
        NSApp
            .windows
            .forEach {
                $0.undoManager?.removeAllActions()
            }
    }
    
    override var canBecomeKeyView: Bool {
        true
    }
    
    override func mouseDown(with: NSEvent) {
        selectText(nil)
    }
}
