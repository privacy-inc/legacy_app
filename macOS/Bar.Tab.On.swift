import AppKit
import Combine

extension Bar.Tab {
    final class On: NSView, NSTextFieldDelegate {
        private weak var stack: NSStackView!
        private weak var status: Status!
        private weak var background: Background!
//        private weak var autocomplete: Autocomplete?
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(status: Status, item: UUID) {
            self.status = status
            
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let background = Background()
            self.background = background
            addSubview(background)
            
            let search = Search()
            search.delegate = self
            
            let prompt = Option(icon: "magnifyingglass", size: 12)
            prompt.toolTip = "Search"
            prompt.click
                .sink {
                    status.search.send()
                }
                .store(in: &subs)
            
            let close = Option(icon: "xmark.app.fill")
            close.toolTip = "Close tab"
            close
                .click
                .sink {
                    status.close(id: item)
                }
                .store(in: &subs)
            
            let trackers = Trackers(status: status, item: item)
            trackers.state = .hidden
            
            let secure = Option(icon: "lock.fill", size: 12)
            secure.toolTip = "Secure connection"
            secure.state = .hidden
            
            let insercure = Option(icon: "exclamationmark.triangle.fill", size: 13)
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
            
            let stack = NSStackView(views: [prompt, close, search, secure, insercure, back, forward, reload, stop, options, trackers])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.spacing = 0
            addSubview(stack)
            
            let widthConstraint = widthAnchor.constraint(equalToConstant: status.widthOn.value)
            widthConstraint.isActive = true
            
            background.topAnchor.constraint(equalTo: topAnchor).isActive = true
            background.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            background.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            background.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            
            stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 3).isActive = true
            stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -6).isActive = true
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
                    prompt.state = $0 != 1 ? .hidden : .on
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
                    if case .list = $0.flow {
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
                    trackers.state = .on
                }
                .store(in: &subs)
            
            status
                .search
                .sink { [weak self] in
                    self?.window!.makeFirstResponder(search)
                }
                .store(in: &subs)
            
            status
                .widthOn
                .dropFirst()
                .sink {
                    widthConstraint.constant = $0
                }
                .store(in: &subs)
        }
        
        deinit {
//            autocomplete?.close()
        }
        
        override func updateLayer() {
            background.updateLayer()
        }
        
        func controlTextDidChange(_ control: Notification) {
            guard let search = control.object as? Search else { return }
            
//            if self.autocomplete == nil {
//                let autocomplete = Autocomplete(status: status)
//                window!.addChildWindow(autocomplete, ordered: .above)
//
//                ;{
//                    autocomplete.adjust.send((position: .init(x: $0.x - 3, y: $0.y - 6), width: bounds.width + 6))
//                } (window!.convertPoint(toScreen: convert(frame.origin, to: nil)))
//
//                autocomplete
//                    .list
//                    .complete
//                    .sink {
//                        search.stringValue = $0
//                    }
//                    .store(in: &subs)
//
//                self.autocomplete = autocomplete
//            }
//
//            autocomplete?.find(string: search.stringValue)
        }
        
        func control(_ control: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
            switch doCommandBy {
            case #selector(cancelOperation), #selector(complete), #selector(NSSavePanel.cancel):
//                autocomplete?.close()
                window?.makeFirstResponder(window?.contentView)
            case #selector(insertNewline):
//                autocomplete?.close()
                Task
                    .detached(priority: .utility) { [weak self] in
                        await self?.status.searching(search: control.stringValue)
                    }
                window!.makeFirstResponder(window!.contentView)
            case #selector(moveUp):
                break
//                autocomplete?.list.move.send((date: .init(), direction: .up))
            case #selector(moveDown):
                break
//                autocomplete?.list.move.send((date: .init(), direction: .down))
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
            
//            secure
//                .click
//                .sink {
//                    Connection(history: web.history)
//                        .show(relativeTo: secure.bounds, of: secure, preferredEdge: .maxY)
//                }
//                .store(in: &subs)
//            
//            insecure
//                .click
//                .sink {
//                    Connection(history: web.history)
//                        .show(relativeTo: insecure.bounds, of: insecure, preferredEdge: .maxY)
//                }
//                .store(in: &subs)
            
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
