import AppKit

extension Control {
    final class Prominent: Control {
        required init?(coder: NSCoder) { nil }
        init(_ title: String) {
            let text = Text(vibrancy: false)
            text.stringValue = title
            text.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .medium)
            text.textColor = .white
            
            super.init(layer: true)
            layer?.cornerRadius = 8
            addSubview(text)
            
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 10).isActive = true
            
            text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            text.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .highlighted, .pressed:
                layer!.backgroundColor = NSColor.systemBlue.withAlphaComponent(0.8).cgColor
            default:
                layer!.backgroundColor = NSColor.systemBlue.cgColor
            }
        }
    }
}
