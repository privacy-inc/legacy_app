import AppKit
import Combine
import Specs

extension Tab {
    final class On: NSView, NSTextFieldDelegate {
        private weak var stack: NSStackView!
        private weak var progress: Progress!
        private weak var autocomplete: Autocomplete?
        private var subs = Set<AnyCancellable>()
        private let id: UUID
        private let session: Session
        
        required init?(coder: NSCoder) { nil }
        init(session: Session, id: UUID, publisher: AnyPublisher<Session.Flow, Never>) {
            self.session = session
            self.id = id
            
            let domain = CurrentValueSubject<_, Never>("")
            
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let progress = Progress()
            self.progress = progress
            addSubview(progress)
            
            let search = Search(session: session)
            search.delegate = self
            
            let prompt = Control.Symbol("magnifyingglass", point: 12, size: Bar.height, weight: .regular, hierarchical: false)
            prompt.toolTip = "Search"
            prompt.click
                .sink {
                    session.focus.send()
                }
                .store(in: &subs)
            
            let close = Control.Symbol("xmark.app.fill", point: 16, size: Bar.height, weight: .regular, hierarchical: false)
            close.toolTip = "Close tab"
            close
                .click
                .sink {
                    session.close(id: id)
                }
                .store(in: &subs)
            
            let counter = Counter(domain: domain)
            
            let secure = Control.Symbol("lock.fill", point: 12, size: Bar.height, weight: .regular, hierarchical: false)
            secure.toolTip = "Secure connection"
            secure.state = .hidden
            secure
                .click
                .sink {
                    NSPopover().show(Secure(session: session, id: id), from: secure, edge: .minY)
                }
                .store(in: &subs)
            
            let insecure = Control.Symbol("exclamationmark.triangle.fill", point: 13, size: Bar.height, weight: .regular, hierarchical: false)
            insecure.toolTip = "Insecure"
            insecure.state = .hidden
            insecure
                .click
                .sink {
                    NSPopover().show(Secure(session: session, id: id), from: insecure, edge: .minY)
                }
                .store(in: &subs)
            
            let options = Control.Symbol("ellipsis.circle.fill", point: 14, size: Bar.height, weight: .regular, hierarchical: false)
            options.toolTip = "Options"
            options.state = .hidden
            options
                .click
                .sink {
                    NSPopover().show(Detail(session: session, id: id), from: options, edge: .minY)
                }
                .store(in: &subs)
            
            let back = Control.Symbol("chevron.backward", point: 13, size: Bar.height, weight: .regular, hierarchical: false)
            back.toolTip = "Back"
            back.state = .hidden
            
            let forward = Control.Symbol("chevron.forward", point: 13, size: Bar.height, weight: .regular, hierarchical: false)
            forward.toolTip = "Forward"
            forward.state = .hidden
            
            let reload = Control.Symbol("arrow.clockwise", point: 12, size: Bar.height, weight: .regular, hierarchical: false)
            reload.toolTip = "Reload"
            reload.state = .hidden
            
            let stop = Control.Symbol("xmark", point: 12, size: Bar.height, weight: .regular, hierarchical: false)
            stop.toolTip = "Stop"
            stop.state = .hidden
            
            let stack = NSStackView(views: [prompt, close, search, secure, insecure, back, forward, reload, stop, options, counter])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.spacing = 0
            addSubview(stack)
            
            let width = widthAnchor.constraint(equalToConstant: session.width.value.on)
            width.isActive = true
            
            progress.topAnchor.constraint(equalTo: topAnchor).isActive = true
            progress.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            progress.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            progress.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            
            stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 3).isActive = true
            stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -6).isActive = true
            stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
            stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
            session
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
            
            session
                .items
                .first()
                .delay(for: .milliseconds(100), scheduler: DispatchQueue.main)
                .compactMap {
                    $0
                        .first {
                            $0.id == id
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
            
            publisher
                .sink {
                    switch $0 {
                    case .list:
                        search.update(url: "")
                        
                        secure.state = .hidden
                        insecure.state = .hidden
                        counter.state = .hidden
                        options.state = .hidden
                    case let .web(web):
                        search.update(url: web.url?.absoluteString ?? "")
                        
                        secure.state = web.hasOnlySecureContent ? .on : .hidden
                        insecure.state = web.hasOnlySecureContent ? .hidden : .on
                        counter.state = .on
                        options.state = .on
                    case let .message(_, url, title, _):
                        search.update(url: url?.absoluteString ?? title)
                        
                        secure.state = .hidden
                        insecure.state = .hidden
                        counter.state = .hidden
                        options.state = .hidden
                    }
                }
                .store(in: &subs)
            
            publisher
                .compactMap {
                    switch $0 {
                    case let .web(web), let .message(web, _, _, _):
                        return web
                    default:
                        return nil
                    }
                }
                .first()
                .sink { [weak self] (web: Web) in
                    self?.add(web
                        .publisher(for: \.url)
                        .compactMap {
                            $0
                        }
                        .removeDuplicates()
                        .sink {
                            search.update(url: $0.absoluteString)
                        })
                    
                    self?.add(web
                        .progress
                        .removeDuplicates()
                        .sink { value in
                            guard value != 1 || progress.shape.strokeEnd != 0 else { return }
                            
                            progress.shape.strokeStart = 0
                            progress.shape.strokeEnd = .init(value)
                            
                            if value == 1 {
                                progress.shape.add({
                                    $0.duration = 1
                                    $0.timingFunction = .init(name: .easeInEaseOut)
                                    $0.delegate = progress
                                    return $0
                                } (CABasicAnimation(keyPath: "strokeEnd")), forKey: "strokeEnd")
                            }
                        })
                    
                    self?.add(web
                        .publisher(for: \.hasOnlySecureContent)
                        .removeDuplicates()
                        .sink {
                            guard case .web = session.flow(of: id) else { return }
                            secure.state = $0 ? .on : .hidden
                            insecure.state = $0 ? .hidden : .on
                        })
                    
                    self?.add(web
                        .publisher(for: \.isLoading)
                        .removeDuplicates()
                        .sink {
                            stop.state = $0 ? .on : .hidden
                            reload.state = $0 ? .hidden : .on
                        })
                    
                    self?.add(web
                        .publisher(for: \.canGoBack)
                        .removeDuplicates()
                        .combineLatest(
                            web
                                .publisher(for: \.canGoForward)
                                .removeDuplicates(), session
                                        .items
                                        .compactMap {
                                            $0
                                                .first {
                                                    $0.id == id
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
                            case .message:
                                back.state = .on
                                forward.state = canGoForward ? .on : .off
                            default:
                                break
                            }
                        })
                    
                    self?.add(reload
                        .click
                        .sink {
                            web.reload(nil)
                        })
                    
                    self?.add(stop
                        .click
                        .sink {
                            web.stopLoading()
                        })
                    
                    self?.add(back
                        .click
                        .sink {
                            web.goBack(nil)
                        })
                    
                    self?.add(forward
                        .click
                        .sink {
                            web.goForward()
                            
                            guard
                                let flow = session.items.value.first(where: { $0.id == id })?.flow,
                                case .message = flow
                            else { return }
                            session.change(flow: .web(web), of: id)
                        })
                    
                    self?.add(web
                        .publisher(for: \.url)
                        .compactMap {
                            $0
                        }
                        .map(\.absoluteString)
                        .removeDuplicates()
                        .map(\.domain)
                        .removeDuplicates()
                        .subscribe(domain))
                }
                .store(in: &subs)
            
            session
                .focus
                .sink { [weak self] in
                    self?.window!.makeFirstResponder(search)
                }
                .store(in: &subs)
            
            session
                .width
                .dropFirst()
                .sink {
                    width.constant = $0.on
                }
                .store(in: &subs)
        }
        
        deinit {
            autocomplete?.close()
        }
        
        override func updateLayer() {
            progress.updateLayer()
        }
        
        func controlTextDidChange(_ control: Notification) {
            guard let search = control.object as? Search else { return }
            
            if session.flow(of: id) != .list {
                if self.autocomplete == nil {
                    let origin = window!.convertPoint(toScreen: convert(frame.origin, to: nil))
                    let autocomplete = Autocomplete(session: session,
                                                    position: .init(x: origin.x - 3, y: origin.y - 6),
                                                    width: bounds.width + 6)
                    window!.addChildWindow(autocomplete, ordered: .above)
                    self.autocomplete = autocomplete
                }
            }
            
            session.filter.send(search.stringValue)
        }
        
        func control(_ control: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
            switch doCommandBy {
            case #selector(cancelOperation), #selector(complete), #selector(NSSavePanel.cancel):
                autocomplete?.close()
                if case let .web(web) = session.flow(of: id) {
                    window?.makeFirstResponder(web)
                } else {
                    window?.makeFirstResponder(window?.contentView)
                }
            case #selector(insertNewline):
                autocomplete?.close()
                Task
                    .detached(priority: .utility) { [session, id] in
                        await session.search(string: control.stringValue, id: id)
                    }
                window!.makeFirstResponder(window!.contentView)
            case #selector(moveUp):
                session.up.send(true)
            case #selector(moveDown):
                session.up.send(false)
            default:
                return false
            }
            return true
        }
        
        private func add(_ cancellable: AnyCancellable) {
            subs.insert(cancellable)
        }
    }
}
