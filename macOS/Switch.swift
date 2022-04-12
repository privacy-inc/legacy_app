import AppKit
import Combine

final class Switch: NSView {
    let change = PassthroughSubject<Bool, Never>()
    private(set) weak var control: NSSwitch!
    
    required init?(coder: NSCoder) { nil }
    init(title: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let text = Text(vibrancy: false)
        text.stringValue = title
        text.font = .preferredFont(forTextStyle: .body)
        text.textColor = .secondaryLabelColor
        addSubview(text)
        
        let control = NSSwitch()
        control.target = self
        control.action = #selector(changing)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.controlSize = .small
        self.control = control
        addSubview(control)
        
        rightAnchor.constraint(equalTo: text.rightAnchor, constant: 6).isActive = true
        bottomAnchor.constraint(equalTo: control.bottomAnchor, constant: 6).isActive = true
        
        text.leftAnchor.constraint(equalTo: control.rightAnchor, constant: 6).isActive = true
        text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        control.leftAnchor.constraint(equalTo: leftAnchor, constant: 6).isActive = true
        control.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
    }
    
    override var allowsVibrancy: Bool {
        true
    }
    
    @objc private func changing() {
        change.send(control.state == .on)
    }
}
