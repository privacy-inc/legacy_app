import AppKit

final class Chart: CALayer {
    private let values: [Double]
    
    required init?(coder: NSCoder) { nil }
    override init(layer: Any) {
        values = []
        super.init(layer: layer)
    }
    
    init(values: [Double]) {
        self.values = values
        super.init()
        frame = .init(x: 0, y: 0, width: 300, height: 210)
        setNeedsDisplay()
    }
    
    override func draw(in context: CGContext) {
        context.setStrokeColor(NSColor.tertiaryLabelColor.cgColor)
        context.setFillColor(NSColor(named: "Shades")!.cgColor)
        context.setLineWidth(1)
        context.addPath({
            if !values.isEmpty {
                $0.addLines(
                    between:
                        values
                            .enumerated()
                            .map {
                                .init(
                                    x: (Double(bounds.maxX - 80) / .init(values.count - 1) * .init($0.0)) + 40,
                                    y: (Double(bounds.maxY - 80) * $0.1) + 40)
                            })
            } else {
                $0.addLine(to: .init(x: bounds.maxX, y: 0))
            }
            return $0
        } (CGMutablePath()))
        context.strokePath()
        context.setLineWidth(0.5)
        context.setStrokeColor(NSColor.secondaryLabelColor.cgColor)
        
        (0 ..< values.count)
            .forEach { index in
                let point = CGPoint(
                    x: (Double(bounds.maxX - 80) / .init(values.count - 1) * .init(index)) + 40,
                    y: (Double(bounds.maxY - 80) * .init(values[index])) + 40)
                context.addArc(
                    center: point,
                    radius: index == values.count - 1 ? 11 : 7,
                    startAngle: .zero,
                    endAngle: .pi * 2,
                    clockwise: false)
                context.setBlendMode(.clear)
                context.fillPath()
                
                context.addArc(
                    center: point,
                    radius: index == values.count - 1 ? 8 : 4,
                    startAngle: .zero,
                    endAngle: .pi * 2,
                    clockwise: false)
                
                context.setBlendMode(.normal)
                
                if index == values.count - 1 {
                    context.fillPath()
                } else {
                    context.strokePath()
                }
            }
    }
}
