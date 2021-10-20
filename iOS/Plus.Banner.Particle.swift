import Foundation

extension Plus.Banner {
    struct Particle {
        let radius: Double
        let x: Double
        let y: Double
        let opacity: Double
        let blue: Bool
        
        static func new() -> Self {
            .init(radius: .random(in: 1 ..< 20),
                  x: .random(in: 20 ..< 230),
                  y: .random(in: 20 ..< 230),
                  opacity: .random(in: 0.05 ..< 0.9),
                  blue: .random())
        }
        
        private init(radius: Double, x: Double, y: Double, opacity: Double, blue: Bool) {
            self.radius = radius
            self.x = x
            self.y = y
            self.opacity = opacity
            self.blue = blue
        }
        
        func tick() -> Self? {
            radius > 0.01 ? .init(radius: radius / 1.005, x: x, y: y, opacity: opacity, blue: blue) : nil
        }
    }
}
