import AppKit

extension Preferences {
    final class Segmented: NSView {
        private(set) weak var control: NSSegmentedControl!
        
        required init?(coder: NSCoder) { nil }
        init(symbol: String, title: String, labels: [String], target: NSTabViewItem, action: Selector) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let icon = NSImageView(image: .init(systemSymbolName: symbol, accessibilityDescription: nil) ?? .init())
            icon.symbolConfiguration = .init(textStyle: .title2)
                .applying(.init(hierarchicalColor: .secondaryLabelColor))
            addSubview(icon)
            
            let text = Text(vibrancy: true)
            text.font = .preferredFont(forTextStyle: .title3)
            text.textColor = .secondaryLabelColor
            text.stringValue = title
            addSubview(text)
            
            let control = NSSegmentedControl(labels: labels, trackingMode: .selectOne, target: target, action: action)
            control.translatesAutoresizingMaskIntoConstraints = false
            control.segmentDistribution = .fit
            control.segmentStyle = .rounded
            self.control = control
            addSubview(control)
            
            bottomAnchor.constraint(equalTo: control.bottomAnchor).isActive = true
            widthAnchor.constraint(equalToConstant: 300).isActive = true
            
            icon.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
            icon.centerXAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
            
            text.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 34).isActive = true
            
            control.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 15).isActive = true
            control.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
