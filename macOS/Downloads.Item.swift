import AppKit
import WebKit

private let size = CGFloat(36)

extension Downloads {
    final class Item: NSView {
        private(set) weak var download: WKDownload?
        
        required init?(coder: NSCoder) { nil }
        init(download: WKDownload?) {
            self.download = download
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let title = Text(vibrancy: true)
            title.stringValue = download?.originalRequest?.url?.absoluteString ?? "file"
            title.font = .preferredFont(forTextStyle: .body)
            title.textColor = .labelColor
            title.lineBreakMode = .byTruncatingTail
            title.maximumNumberOfLines = 1
            title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            let base = NSView()
            base.translatesAutoresizingMaskIntoConstraints = false
            
            let bar = Separator()
            bar.layer!.cornerRadius = 3
            base.addSubview(bar)
            
            let progress = NSView()
            progress.translatesAutoresizingMaskIntoConstraints = false
            progress.wantsLayer = true
            progress.layer!.cornerRadius = bar.layer!.cornerRadius
            progress.layer!.backgroundColor = NSColor.systemBlue.cgColor
            base.addSubview(progress)
            
            let weight = Text(vibrancy: true)
            weight.stringValue = "123.5 MB"
            weight.font = .preferredFont(forTextStyle: .callout)
            weight.textColor = .labelColor
            weight.maximumNumberOfLines = 1
            
            let stop = Control.Symbol("xmark.circle.fill", point: 18, size: size, weight: .regular, hierarchical: true)
            let again = Control.Symbol("arrow.clockwise.circle.fill", point: 18, size: size, weight: .regular, hierarchical: true)
            let show = Control.Symbol("magnifyingglass.circle.fill", point: 18, size: size, weight: .regular, hierarchical: true)
            
            let stack = Stack(views: [title, base, weight, stop, again, show])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.distribution = .fill
            stack.alignment = .centerY
            addSubview(stack)
            
            let separator = Separator()
            addSubview(separator)
            
            heightAnchor.constraint(equalToConstant: size).isActive = true
            
            base.widthAnchor.constraint(equalToConstant: 200).isActive = true
            base.heightAnchor.constraint(equalToConstant: size).isActive = true
            
            bar.centerYAnchor.constraint(equalTo: base.centerYAnchor).isActive = true
            bar.leftAnchor.constraint(equalTo: base.leftAnchor).isActive = true
            bar.rightAnchor.constraint(equalTo: base.rightAnchor).isActive = true
            bar.heightAnchor.constraint(equalToConstant: 6).isActive = true
            
            progress.topAnchor.constraint(equalTo: bar.topAnchor).isActive = true
            progress.leftAnchor.constraint(equalTo: bar.leftAnchor).isActive = true
            progress.bottomAnchor.constraint(equalTo: bar.bottomAnchor).isActive = true
            
            separator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1).isActive = true
            separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
            stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            let width = stack.widthAnchor.constraint(equalToConstant: 500)
            width.priority = .defaultLow
            width.isActive = true
            
            progress.widthAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
}
