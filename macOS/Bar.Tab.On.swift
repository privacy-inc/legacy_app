import AppKit
import Combine

extension Bar.Tab {
    final class On: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(status: Status, item: Status.Item) {
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
    }
}
