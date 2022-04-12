import Foundation

extension Banner {
    struct Particle {
        let radius: Double
        let x: Double
        let y: Double
        let opacity: Double
        let blue: Bool
        private let decrease: Double
        
        static func new() -> Self {
            .init(radius: .random(in: 0.6 ... 20),
                  x: .random(in: 20 ..< 360),
                  y: .random(in: 20 ..< 200),
                  opacity: .random(in: 0.035 ..< 0.97),
                  blue: .random(),
                  decrease: .random(in: 1.000015 ..< 1.05))
        }
        
        private init(radius: Double, x: Double, y: Double, opacity: Double, blue: Bool, decrease: Double) {
            self.radius = radius
            self.x = x
            self.y = y
            self.opacity = opacity
            self.blue = blue
            self.decrease = decrease
        }
        
        func tick() -> Self? {
            radius > 0.15 ? .init(radius: radius / decrease, x: x, y: y, opacity: opacity, blue: blue, decrease: decrease) : nil
        }
    }
}
