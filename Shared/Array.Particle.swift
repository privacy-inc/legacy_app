extension Array where Element == Particle {
    func tick(width: Double, height: Double) -> Self {
        var particles = self
            .compactMap {
                $0.tick()
            }
        
        if Int.random(in: 0 ..< 6) == 0 {
            particles.append(.init(radius: .random(in: 0.6 ... 20),
                                   x: .random(in: 20 ..< (width - 20)),
                                   y: .random(in: 20 ..< (height - 20)),
                                   opacity: .random(in: 0.035 ..< 0.97),
                                   blue: .random(),
                                   decrease: .random(in: 1.000015 ..< 1.05)))
        }
        
        return particles
    }
}
