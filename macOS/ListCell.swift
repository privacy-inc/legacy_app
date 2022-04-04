import AppKit

final class ListCell: CollectionCell<ListInfo> {
    private weak var text: Text!
    private weak var icon: Icon!
    private weak var separator: Shape!
    private weak var vibrant: Vibrant!
    
    override var item: CollectionItem<ListInfo>? {
        didSet {
            guard
                item != oldValue,
                let item = item
            else { return }
            
            separator.isHidden = item.info.first
            separator.path = .init(rect: .init(x: 30, y: item.rect.height + 1, width: item.rect.width - 60, height: 0), transform: nil)
            
            if item.rect != oldValue?.rect {
                frame = item.rect
                vibrant.frame = bounds
            }
            
            if item.info != oldValue?.info {
                text.attributedStringValue = item.info.text
                icon.icon(website: item.info.website.id)
            }
        }
    }
    
    required init?(coder: NSCoder) { nil }
    required init() {
        let vibrant = Vibrant(layer: true)
        vibrant.layer!.cornerCurve = .continuous
        vibrant.layer!.cornerRadius = 12
        self.vibrant = vibrant
        
        let separator = Shape()
        separator.fillColor = .clear
        separator.lineWidth = 1
        self.separator = separator
        
        super.init()
        addSubview(vibrant)
        layer!.masksToBounds = false
        layer!.addSublayer(separator)
        
        let icon = Icon()
        addSubview(icon)
        self.icon = icon
        
        let text = Text(vibrancy: true)
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        text.maximumNumberOfLines = 3
        addSubview(text)
        self.text = text
        
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        
        text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        text.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 4).isActive = true
        text.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        text.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 1).isActive = true
        text.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -1).isActive = true
    }
    
    override func updateLayer() {
        switch state {
        case .highlighted, .pressed:
            vibrant.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.07).cgColor
        default:
            vibrant.layer!.backgroundColor = .clear
        }
        
        separator.strokeColor = NSColor.labelColor.withAlphaComponent(0.07).cgColor
    }
}
