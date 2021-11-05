import AppKit

final class Search: NSTextField {
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
        
//        cloud
//            .archive
//            .combineLatest(session
//                            .tab
//                            .items
//                            .map {
//                                $0[state: id]
//                                    .browse
//                            }
//                            .compactMap {
//                                $0
//                            })
//            .map {
//                $0.0
//                    .page($0.1)
//                    .access
//            }
//            .combineLatest(responder)
//            .compactMap {
//                $1
//                    ? nil
//                    : {
//                        switch $0 {
//                        case let .remote(remote):
//                            return remote.domain + remote.suffix
//                        default:
//                            return $0.short
//                        }
//                    } ($0)
//            }
//            .sink { [weak self] (short: String) in
//                self?.stringValue = short
//                
//                if self?.autocomplete.isVisible == true {
//                    self?.autocomplete.end()
//                }
//            }
//            .store(in: &subs)
//        
//        responder
//            .filter {
//                $0
//            }
//            .compactMap { _ in
//                session
//                    .tab
//                    .items
//                    .value[state: id]
//                    .browse
//                    .flatMap(cloud.archive.value.page)
//                    .map(\.access.value)
//            }
//            .sink { [weak self] in
//                self?.stringValue = $0
//            }
//            .store(in: &subs)
//            
//        session
//            .search
//            .filter {
//                $0 == id
//            }
//            .map { _ in
//                
//            }
//            .sink { [weak self] in
//                self?.window?.makeFirstResponder(self)
//            }
//            .store(in: &subs)
//        
//        autocomplete
//            .complete
//            .sink { [weak self] in
//                self?.stringValue = $0
//            }
//            .store(in: &subs)
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
