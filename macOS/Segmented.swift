import AppKit
import Combine

final class Segmented: NSView {
    let change = PassthroughSubject<Int, Never>()
    private(set) weak var control: NSSegmentedControl!
    
    required init?(coder: NSCoder) { nil }
    init(symbol: String, title: String, labels: [String]) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let icon = NSImageView(image: .init(systemSymbolName: symbol, accessibilityDescription: nil) ?? .init())
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.symbolConfiguration = .init(pointSize: 16, weight: .regular)
            .applying(.init(hierarchicalColor: .labelColor))
        addSubview(icon)
        
        let text = Text(vibrancy: false)
        text.font = .preferredFont(forTextStyle: .body)
        text.textColor = .secondaryLabelColor
        text.stringValue = title
        addSubview(text)
        
        let control = NSSegmentedControl(labels: labels, trackingMode: .selectOne, target: self, action: #selector(changing))
        control.translatesAutoresizingMaskIntoConstraints = false
        control.segmentDistribution = .fillEqually
        control.segmentStyle = .rounded
        self.control = control
        addSubview(control)
        
        bottomAnchor.constraint(equalTo: control.bottomAnchor, constant: 5).isActive = true
        rightAnchor.constraint(equalTo: control.rightAnchor, constant: 5).isActive = true
        
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        icon.centerXAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        
        text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        text.leftAnchor.constraint(equalTo: leftAnchor, constant: 45).isActive = true
        text.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        control.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        control.leftAnchor.constraint(equalTo: text.rightAnchor).isActive = true
    }
    
    override var allowsVibrancy: Bool {
        true
    }
    
    @objc private func changing() {
        change.send(control.selectedSegment)
    }
}
