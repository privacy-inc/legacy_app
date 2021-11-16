import AppKit
import Specs

final class Recover: NSView {
    required init?(coder: NSCoder) { nil }
    init(error: Err) {
        super.init(frame: .zero)
        
        let icon = Image(icon: "exclamationmark.triangle.fill", vibrancy: false)
        icon.symbolConfiguration = .init(textStyle: .largeTitle, scale: .large)
            .applying(.init(hierarchicalColor: .systemPink))
        addSubview(icon)
        
        let url = Text(vibrancy: true)
        url.stringValue = error.url.absoluteString
        url.lineBreakMode = .byTruncatingTail
        url.maximumNumberOfLines = 1
        url.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .light)
        url.textColor = .secondaryLabelColor
        addSubview(url)
        
        let description = Text(vibrancy: true)
        description.stringValue = error.description
        description.maximumNumberOfLines = 0
        description.font = .preferredFont(forTextStyle: .title3)
        description.textColor = .labelColor
        description.alignment = .center
        addSubview(description)
        
        icon.topAnchor.constraint(equalTo: topAnchor, constant: 100).isActive = true
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        url.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20).isActive = true
        url.widthAnchor.constraint(lessThanOrEqualToConstant: 340).isActive = true
        url.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        description.topAnchor.constraint(equalTo: url.bottomAnchor, constant: 2).isActive = true
        description.widthAnchor.constraint(lessThanOrEqualToConstant: 260).isActive = true
        description.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
