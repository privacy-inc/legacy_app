import AppKit

extension Preferences {
    final class Segmented: NSView {
        private(set) weak var control: NSSegmentedControl!
        
        required init?(coder: NSCoder) { nil }
        init(title: String, labels: [String], target: NSTabViewItem, action: Selector) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let text = Text(vibrancy: true)
            text.font = .preferredFont(forTextStyle: .body)
            text.textColor = .tertiaryLabelColor
            text.stringValue = title
            addSubview(text)
            
            let control = NSSegmentedControl(labels: labels, trackingMode: .selectOne, target: target, action: action)
            control.translatesAutoresizingMaskIntoConstraints = false
            self.control = control
            addSubview(control)
            
            text.topAnchor.constraint(equalTo: topAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            
            control.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 5).isActive = true
            control.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            control.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            control.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            control.widthAnchor.constraint(equalToConstant: 320).isActive = true
        }
    }
}
