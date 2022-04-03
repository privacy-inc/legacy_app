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
            separator.path = .init(rect: .init(x: 20, y: 57, width: item.rect.width - 40, height: 0), transform: nil)
            
            if item.rect != oldValue?.rect {
                frame = item.rect
                vibrant.frame = bounds
                
                let width = item.rect.size.width - 70
                let height = item.info.text.height(for: width)
                text.frame = .init(
                    x: 54,
                    y: (item.rect.height - height) / 2,
                    width: width,
                    height: height)
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
        vibrant.layer!.cornerRadius = 8
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
        icon.translatesAutoresizingMaskIntoConstraints = true
        icon.frame = .init(
            x: 16,
            y: 16,
            width: 24,
            height: 24)
        addSubview(icon)
        self.icon = icon
        
        let text = Text(vibrancy: true)
        text.translatesAutoresizingMaskIntoConstraints = true
        addSubview(text)
        self.text = text
    }
    
    override func updateLayer() {
        switch state {
        case .highlighted, .pressed:
            vibrant.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
        default:
            vibrant.layer!.backgroundColor = .clear
        }
        
        separator.strokeColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
    }
}
