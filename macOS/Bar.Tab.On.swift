import AppKit
import Combine

extension Bar.Tab {
    final class On: NSView, NSTextFieldDelegate {
        private var subs = Set<AnyCancellable>()
        private let status: Status
        
        required init?(coder: NSCoder) { nil }
        init(status: Status, item: Status.Item) {
            self.status = status
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            layer = Privacy.Layer()
            wantsLayer = true
            layer!.cornerRadius = 8
            layer!.cornerCurve = .continuous
            layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.15).cgColor
            
            let prompt = Image(icon: "magnifyingglass")
            prompt.symbolConfiguration = .init(pointSize: 12, weight: .regular)
            prompt.contentTintColor = .tertiaryLabelColor
            addSubview(prompt)
            
            let search = Search()
            search.delegate = self
            addSubview(search)
            
            let close = Option(icon: "xmark.app.fill")
            close.toolTip = "Close tab"
            close
                .click
                .sink {
                    status.close(id: item.id)
                }
                .store(in: &subs)
            addSubview(close)
            
            let options = Option(icon: "ellipsis")
            options
                .click
                .sink {
                    
                }
                .store(in: &subs)
            options.state = .hidden
            addSubview(options)
            
            status
                .flows
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
                .flows
                .first()
                .delay(for: .milliseconds(100), scheduler: DispatchQueue.main)
                .compactMap {
                    $0
                        .first {
                            $0.id == item.id
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
            
            prompt.centerXAnchor.constraint(equalTo: close.centerXAnchor).isActive = true
            prompt.centerYAnchor.constraint(equalTo: close.centerYAnchor).isActive = true
            
            close.leftAnchor.constraint(equalTo: leftAnchor, constant: 3).isActive = true
            close.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            options.rightAnchor.constraint(equalTo: rightAnchor, constant: -3).isActive = true
            options.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            search.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            search.leftAnchor.constraint(equalTo: close.rightAnchor).isActive = true
            search.rightAnchor.constraint(equalTo: options.leftAnchor).isActive = true
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
    }
}
