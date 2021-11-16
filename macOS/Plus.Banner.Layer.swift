import AppKit

extension Plus.Banner {
    final class Layer: CALayer {
        let model = Model()
        private let pi2 = Double.pi * 2
        private let shades = NSColor(named: "Shades")!
        private let dawn = NSColor(named: "Dawn")!
        
        override func draw(in context: CGContext) {
            model.tick()
            
            context.setLineWidth(6)
            context.setLineCap(.square)
            
            model
                .particles
                .forEach { particle in
                    context
                        .addArc(
                            center: .init(x: particle.x, y: particle.y),
                            radius: particle.radius,
                            startAngle: .zero,
                            endAngle: .pi * 2,
                            clockwise: true)
                    
                    context.setFillColor(particle.blue
                                         ? shades.withAlphaComponent(particle.opacity).cgColor
                                         : dawn.withAlphaComponent(particle.opacity).cgColor)
                    
                    context.fillPath()
                }
            
            model
                .shines
                .forEach { shine in
                    context
                        .addArc(center: .init(x: shine.x, y: 250 - shine.y),
                                radius: 25,
                                startAngle: shine.start,
                                endAngle: shine.start + shine.length,
                                clockwise: shine.clockwise)
                    
                    context.setStrokeColor(shine.blue
                                           ? shades.withAlphaComponent(0.2).cgColor
                                           : dawn.withAlphaComponent(0.2).cgColor)
                    context.strokePath()
                }
        }
        
        override class func defaultAction(forKey: String) -> CAAction? {
            NSNull()
        }
        
        override func hitTest(_: CGPoint) -> CALayer? {
            nil
        }
    }
}
