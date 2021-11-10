import AppKit
import Combine

extension Bar.Tab {
    final class On: NSView, NSTextFieldDelegate {
        private var subs = Set<AnyCancellable>()
        private weak var stack: NSStackView!
        private weak var status: Status!
        
        required init?(coder: NSCoder) { nil }
        init(status: Status, item: UUID) {
            self.status = status
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let background = Background()
            addSubview(background)
            
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
            
            let options = Option(icon: "ellipsis.circle.fill", size: 14)
            options.toolTip = "Options"
            options.state = .hidden
            
            let back = Option(icon: "chevron.backward", size: 13)
            back.toolTip = "Back"
            back.state = .hidden
            
            let forward = Option(icon: "chevron.forward", size: 13)
            forward.toolTip = "Forward"
            forward.state = .hidden
            
            let reload = Option(icon: "arrow.clockwise", size: 12)
            reload.toolTip = "Reload"
            reload.state = .hidden
            
            let stop = Option(icon: "xmark", size: 12)
            stop.toolTip = "Stop"
            stop.state = .hidden
            
            let stack = NSStackView(views: [prompt, close, search, secure, insercure, back, forward, reload, stop, options])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.spacing = 0
            addSubview(stack)
            
            widthAnchor.constraint(equalToConstant: 350).isActive = true
            
            background.topAnchor.constraint(equalTo: topAnchor).isActive = true
            background.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            background.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            background.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            
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
                    self?.listen(web: web,
                                 status: status,
                                 item: item,
                                 search: search,
                                 secure: secure,
                                 insecure: insercure,
                                 back: back,
                                 forward: forward,
                                 reload: reload,
                                 stop: stop,
                                 options: options)
                    
                    background.listen(web: web)
                    options.state = .on
                }
                .store(in: &subs)
            
            status
                .search
                .sink { [weak self] in
                    self?.window!.makeFirstResponder(search)
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
        
        private func listen(web: Web,
                            status: Status,
                            item: UUID,
                            search: Search,
                            secure: Option,
                            insecure: Option,
                            back: Option,
                            forward: Option,
                            reload: Option,
                            stop: Option,
                            options: Option) {
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
                                            $0.id == item
                                        }?
                                        .flow
                                }
                                .removeDuplicates())
                .sink { url, flow in
                    
                    switch flow {
                    case .web:
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
                        
                    case let .error(_, error):
                        secure.state = .hidden
                        insecure.state = .hidden
                        search.stringValue = error.url.absoluteString
                    default:
                        break
                    }
                    
                    search.undoManager?.removeAllActions()
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
                .combineLatest(
                    web
                        .publisher(for: \.canGoForward)
                        .removeDuplicates(), status
                                .items
                                .compactMap {
                                    $0
                                        .first {
                                            $0.id == item
                                        }?
                                        .flow
                                }
                                .removeDuplicates())
                .sink { canGoBack, canGoForward , flow in
                    
                    switch flow {
                    case .web:
                        back.state = canGoBack
                            ? .on
                            : canGoForward
                                ? .off
                                : .hidden
                        forward.state = canGoForward
                            ? .on
                            :  canGoBack
                                ? .off
                                : .hidden
                    case .error:
                        back.state = .on
                        forward.state = canGoForward ? .on : .off
                    default:
                        break
                    }
                }
                .store(in: &subs)
            
            reload
                .click
                .sink {
                    guard let flow = status.items.value.first(where: { $0.id == item })?.flow else { return }
                    
                    switch flow {
                    case .web:
                        web.reload()
                    case .error:
                        web.tryAgain()
                    default:
                        break
                    }
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
                    guard let flow = status.items.value.first(where: { $0.id == item })?.flow else { return }
                    
                    switch flow {
                    case .web:
                        web.goBack()
                    case .error:
                        web.dismiss()
                    default:
                        break
                    }
                }
                .store(in: &subs)
            
            forward
                .click
                .sink {
                    web.goForward()
                    
                    guard
                        let flow = status.items.value.first(where: { $0.id == item })?.flow,
                        case .error = flow
                    else { return }
                    status.change(flow: .web(web), id: item)
                }
                .store(in: &subs)
            
            secure
                .click
                .sink {
                    Connection(history: web.history)
                        .show(relativeTo: secure.bounds, of: secure, preferredEdge: .maxY)
                }
                .store(in: &subs)
            
            insecure
                .click
                .sink {
                    Connection(history: web.history)
                        .show(relativeTo: insecure.bounds, of: insecure, preferredEdge: .maxY)
                }
                .store(in: &subs)
            
            options
                .click
                .sink {
                    let pop = Ellipsis(web: web, origin: options)
                    pop.show(relativeTo: options.bounds, of: options, preferredEdge: .maxY)
                    pop.contentViewController!.view.window!.makeKey()
                }
                .store(in: &subs)
        }
    }
}
