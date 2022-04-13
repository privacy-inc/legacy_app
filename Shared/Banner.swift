import Foundation

struct Banner {
    private(set) var particles = [Particle]()
    private let width: Double
    private let height: Double
    
    init(width: Double, height: Double) {
        self.width = width - 20
        self.height = height - 20
    }
    
    mutating func tick() {
        particles = particles
            .compactMap {
                $0.tick()
            }
        if Int.random(in: 0 ..< 6) == 0 {
            particles.append(.init(radius: .random(in: 0.6 ... 20),
                                   x: .random(in: 20 ..< width),
                                   y: .random(in: 20 ..< height),
                                   opacity: .random(in: 0.035 ..< 0.97),
                                   blue: .random(),
                                   decrease: .random(in: 1.000015 ..< 1.05)))
        }
    }
}
