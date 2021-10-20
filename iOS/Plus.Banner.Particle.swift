import Foundation

extension Plus.Banner {
    struct Particle {
        let radius: Double
        let x: Double
        let y: Double
        let opacity: Double
        let blue: Bool
        private let decrease: Double
        
        static func new() -> Self {
            .init(radius: .random(in: 1 ... 20),
                  x: .random(in: 20 ..< 230),
                  y: .random(in: 20 ..< 230),
                  opacity: .random(in: 0.02 ..< 0.9),
                  blue: .random(),
                  decrease: .random(in: 1.0002 ..< 1.035))
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
            radius > 0.01 ? .init(radius: radius / decrease, x: x, y: y, opacity: opacity, blue: blue, decrease: decrease) : nil
        }
    }
}
