import Foundation

struct Banner {
    private(set) var particles = [Particle]()
    
    mutating func tick() {
        particles = particles
            .compactMap {
                $0.tick()
            }
        if Int.random(in: 0 ..< 10) == 0 {
            particles.append(.new())
        }
    }
}
