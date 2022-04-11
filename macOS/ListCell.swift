import AppKit

final class ListCell: CollectionCell<ListInfo> {
    private weak var text: Text!
    private weak var icon: Icon!
    private weak var separator: Vibrant!
    private weak var vibrant: Vibrant!
    
    override var item: CollectionItem<ListInfo>? {
        didSet {
            guard
                item != oldValue,
                let item = item
            else { return }
            
            separator.isHidden = item.info.first
            
            if item.rect != oldValue?.rect {
                frame = item.rect
            }
            
            if item.info != oldValue?.info {
                text.attributedStringValue = item.info.text
                icon.icon(website: .init(string: item.info.website.id))
            }
        }
    }
    
    required init?(coder: NSCoder) { nil }
    required init() {
        let vibrant = Vibrant(layer: true)
        vibrant.layer!.cornerCurve = .continuous
        vibrant.layer!.cornerRadius = 12
        self.vibrant = vibrant
        
        let separator = Vibrant(layer: true)
        self.separator = separator
        
        super.init()
        addSubview(vibrant)
        addSubview(separator)
        layer!.masksToBounds = false
        
        let icon = Icon()
        addSubview(icon)
        self.icon = icon
        
        let text = Text(vibrancy: true)
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        text.maximumNumberOfLines = 2
        addSubview(text)
        self.text = text
        
        vibrant.topAnchor.constraint(equalTo: topAnchor).isActive = true
        vibrant.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        vibrant.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        vibrant.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        separator.bottomAnchor.constraint(equalTo: topAnchor, constant: -0.5).isActive = true
        
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        
        text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        text.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 8).isActive = true
        text.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
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
        
        separator.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.07).cgColor
    }
}
