import AppKit

private let pi2 = Double.pi * 2

extension About {
    final class Layer: CALayer {
        private var particles = [Banner.Particle]()
        private let banner = Banner(width: 620, height: 220)
        private let shades = NSColor(named: "Shades")!
        private let dawn = NSColor(named: "Dawn")!
        
        override func draw(in context: CGContext) {
            particles = banner.tick(particles: particles)
            
            particles
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
        }
        
        override class func defaultAction(forKey: String) -> CAAction? {
            NSNull()
        }
        
        override func hitTest(_: CGPoint) -> CALayer? {
            nil
        }
    }
}
