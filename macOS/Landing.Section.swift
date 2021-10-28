import AppKit

extension Landing {
    class Section: NSView {
        private(set) weak var header: Text!
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let header = Text(vibrancy: true)
            header.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .medium)
            header.textColor = .tertiaryLabelColor
            self.header = header
            addSubview(header)
            
            header.topAnchor.constraint(equalTo: topAnchor).isActive = true
            header.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        }
    }
}
