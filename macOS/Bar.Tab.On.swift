import AppKit
import Combine

extension Bar.Tab {
    final class On: NSView, NSTextFieldDelegate {
        private var subs = Set<AnyCancellable>()
        private weak var stack: NSStackView!
        private let status: Status
        
        required init?(coder: NSCoder) { nil }
        init(status: Status, item: UUID) {
            self.status = status
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            layer = Privacy.Layer()
            wantsLayer = true
            layer!.cornerRadius = 8
            layer!.cornerCurve = .continuous
            layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.15).cgColor
            
            let search = Search()
            search.delegate = self
            
            let prompt = Image(icon: "magnifyingglass")
            prompt.symbolConfiguration = .init(pointSize: 12, weight: .regular)
            prompt.contentTintColor = .tertiaryLabelColor
            
            let close = Option(icon: "xmark.app.fill")
            close.toolTip = "Close tab"
            close
                .click
                .sink {
                    status.close(id: item)
                }
                .store(in: &subs)
            
            let secure = Option(icon: "lock.fill", size: 11, color: .tertiaryLabelColor)
            secure.toolTip = "Secure connection"
            secure.state = .hidden
            
            let insercure = Option(icon: "exclamationmark.triangle.fill", size: 11, color: .tertiaryLabelColor)
            insercure.toolTip = "Insecure"
            insercure.state = .hidden
            
            let options = Option(icon: "ellipsis.circle.fill", size: 15)
            options.toolTip = "Options"
            options.state = .hidden
            
            let back = Option(icon: "chevron.backward", size: 14)
            back.toolTip = "Back"
            back.state = .hidden
            
            let forward = Option(icon: "chevron.forward", size: 14)
            forward.toolTip = "Forward"
            forward.state = .hidden
            
            let reload = Option(icon: "arrow.clockwise", size: 14)
            reload.toolTip = "Reload"
            reload.state = .hidden
            
            let stop = Option(icon: "xmark", size: 14)
            stop.toolTip = "Stop"
            stop.state = .hidden
            
            let stack = NSStackView(views: [prompt, close, search, secure, insercure, back, forward, reload, stop, options])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.spacing = 0
            addSubview(stack)
            
            widthAnchor.constraint(equalToConstant: 350).isActive = true
            
            prompt.widthAnchor.constraint(equalToConstant: 28).isActive = true
            
            stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 3).isActive = true
            stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -3).isActive = true
            stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
            stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
            status
                .items
                .map {
                    $0.count
                }
                .removeDuplicates()
                .sink {
                    close.state = $0 == 1 ? .hidden : .on
                    prompt.isHidden = $0 != 1
                }
                .store(in: &subs)
            
            status
                .items
                .first()
                .delay(for: .milliseconds(100), scheduler: DispatchQueue.main)
                .compactMap {
                    $0
                        .first {
                            $0.id == item
                        }
                }
                .filter {
                    if case .landing = $0.flow {
                        return true
                    }
                    return false
                }
                .sink { [weak self] _ in
                    guard self?.window?.firstResponder is Search.Cell.Editor else {
                        self?.window?.makeFirstResponder(search)
                        return
                    }
                }
                .store(in: &subs)
            
            status
                .items
                .compactMap {
                    $0
                        .first {
                            $0.id == item
                        }
                }
                .compactMap {
                    switch $0.flow {
                    case let .web(web), let .error(web, _):
                        return web
                    default:
                        return nil
                    }
                }
                .first()
                .sink { [weak self] (web: Web) in
                    self?.web(web: web,
                              search: search,
                              secure: secure,
                              insecure: insercure,
                              back: back,
                              forward: forward,
                              reload: reload,
                              stop: stop)
                    options.state = .on
                }
                .store(in: &subs)
        }
        
        func controlTextDidChange(_: Notification) {
            
        }
        
//        override func textDidChange(_: Notification) {
    //        if !autocomplete.isVisible {
    //            window!.addChildWindow(autocomplete, ordered: .above)
    //            autocomplete.start()
    //
    //            ;{
    //                autocomplete.adjust.send((position: .init(x: $0.x - 14, y: $0.y - 1.5), width: bounds.width + 28))
    //            } (window!.convertPoint(toScreen: superview!.convert(frame.origin, to: nil)))
    //        }
    //        autocomplete
    //            .filter
    //            .send(stringValue.trimmingCharacters(in: .whitespacesAndNewlines))
//        }
        
        func control(_ control: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
            switch doCommandBy {
            case #selector(cancelOperation), #selector(complete), #selector(NSSavePanel.cancel):
                /*
                 if autocomplete.isVisible {
                     autocomplete.end()
                 } else {
                     window!.makeFirstResponder(superview!)
                 }
                 */
                break
            case #selector(insertNewline):
                /*
                 autocomplete.end()
                 
                 let state = session.tab.items.value[state: id]
                 cloud
                     .browse(stringValue, browse: state.browse) { [weak self] in
                         guard let id = self?.id else { return }
                         if state.browse == $0 {
                             if state.isError {
                                 self?.session.tab.browse(id, $0)
                             }
                             self?.session.load.send((id: id, access: $1))
                         } else {
                             self?.session.tab.browse(id, $0)
                         }
                     }
                 window!.makeFirstResponder(window!.contentView)
                 */
                Task
                    .detached(priority: .utility) { [weak self] in
                        await self?.status.searching(search: control.stringValue)
                    }
                window!.makeFirstResponder(window!.contentView)
                break
            case #selector(moveUp):
                //autocomplete.up.send(.init())
                break
            case #selector(moveDown):
                //autocomplete.down.send(.init())
                break
            default:
                return false
            }
            return true
        }
        
        private func web(web: Web,
                         search: Search,
                         secure: Option,
                         insecure: Option,
                         back: Option,
                         forward: Option,
                         reload: Option,
                         stop: Option) {
            web
                .publisher(for: \.url)
                .compactMap {
                    $0
                }
                .removeDuplicates()
                .sink { url in
                    switch url.scheme?.lowercased() {
                    case "https":
                        secure.state = .on
                        insecure.state = .hidden
                    case "http":
                        secure.state = .hidden
                        insecure.state = .on
                    default:
                        secure.state = .hidden
                        insecure.state = .hidden
                    }
                    
                    var string = url
                        .absoluteString
                        .replacingOccurrences(of: "https://", with: "")
                    
                    if string.last == "/" {
                        string.removeLast()
                    }
                    
                    search.stringValue = string
                }
                .store(in: &subs)
            
            web
                .publisher(for: \.isLoading)
                .removeDuplicates()
                .sink {
                    stop.state = $0 ? .on : .hidden
                    reload.state = $0 ? .hidden : .on
                }
                .store(in: &subs)
            
            web
                .publisher(for: \.canGoBack)
                .removeDuplicates()
                .sink {
                    back.state = $0 ? .on : .hidden
                }
                .store(in: &subs)
            
            web
                .publisher(for: \.canGoForward)
                .removeDuplicates()
                .sink {
                    forward.state = $0 ? .on : .hidden
                }
                .store(in: &subs)
            
            reload
                .click
                .sink {
                    web.reload()
                }
                .store(in: &subs)
            
            stop
                .click
                .sink {
                    web.stopLoading()
                }
                .store(in: &subs)
            
            back
                .click
                .sink {
                    web.goBack()
                }
                .store(in: &subs)
            
            forward
                .click
                .sink {
                    web.goForward()
                }
                .store(in: &subs)
            
            secure
                .click
                .sink {
                    Connection(history: web.history)
                        .show(relativeTo: secure.bounds, of: secure, preferredEdge: .minY)
                }
                .store(in: &subs)
            
            insecure
                .click
                .sink {
                    Connection(history: web.history)
                        .show(relativeTo: insecure.bounds, of: insecure, preferredEdge: .minY)
                }
                .store(in: &subs)
        }
    }
}