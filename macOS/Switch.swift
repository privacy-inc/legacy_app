import AppKit

final class Switch: NSView {
    private(set) var control: NSSwitch!
    
    required init?(coder: NSCoder) { nil }
    init(title: String, target: AnyObject, action: Selector) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let text = Text(vibrancy: true)
        text.stringValue = title
        text.font = .preferredFont(forTextStyle: .title3)
        text.textColor = .secondaryLabelColor
        addSubview(text)
        
        let control = NSSwitch()
        control.target = target
        control.action = action
        control.translatesAutoresizingMaskIntoConstraints = false
        self.control = control
        addSubview(control)
        
        heightAnchor.constraint(equalToConstant: 38).isActive = true
        rightAnchor.constraint(equalTo: text.rightAnchor).isActive = true
        
        text.leftAnchor.constraint(equalTo: control.rightAnchor, constant: 10).isActive = true
        text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        control.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        control.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    override var allowsVibrancy: Bool {
        true
    }
}
