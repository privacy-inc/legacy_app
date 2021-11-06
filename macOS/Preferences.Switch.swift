import AppKit
import Combine

extension Preferences {
    final class Switch: NSView {
        let value = PassthroughSubject<Bool, Never>()
        private var sub: AnyCancellable?
        
        required init?(coder: NSCoder) { nil }
        init(title: String) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let text = Text(vibrancy: true)
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .callout)
            text.textColor = .labelColor
            addSubview(text)
            
            let toggle = NSSwitch()
            toggle.target = self
            toggle.action = #selector(change)
            toggle.translatesAutoresizingMaskIntoConstraints = false
            addSubview(toggle)
            
            heightAnchor.constraint(equalToConstant: 38).isActive = true
            widthAnchor.constraint(equalToConstant: 180).isActive = true
            
            text.leftAnchor.constraint(equalTo: toggle.rightAnchor, constant: 10).isActive = true
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            toggle.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
            toggle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            sub = value
                .sink {
                    toggle.state = $0 ? .on : .off
                }
        }
        
        @objc private func change(_ toggle: NSSwitch) {
            value.send(toggle.state == .on)
        }
    }
}
