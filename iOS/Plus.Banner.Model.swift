import Foundation

extension Plus.Banner {
    final class Model {
        private(set) var particles = [Particle]()
        private(set) var shines: [Shine]
        
        init() {
            shines = (0 ..< 80)
                .map { _ in
                    .new()
                }
        }
        
        func tick() {
            particles = particles
                .compactMap {
                    $0.tick()
                }
            if Int.random(in: 0 ..< 10) == 0 {
                particles.append(.new())
            }
            
            shines = shines
                .compactMap {
                    $0.tick()
                }
            if Int.random(in: 0 ..< 12) == 0 {
                shines.append(.new())
            }
        }
    }
}
